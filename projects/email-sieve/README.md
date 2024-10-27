# Filtering Email with Sieve Scripts

[Sieve](https://en.m.wikipedia.org/wiki/Sieve_(mail_filtering_language)) is a scripting language used by ProtonMail to facilitate processing logic for incoming (and now, existing) emails.  

Before I migrated from Gmail to ProtonMail, I habituated retaining every email I'd ever received. I had ~110,000 emails to (encrypt and) migrate onto ProtonMail's poor servers. On the web client, this entailed noticibly slow loading of folder and mail contents. On the Android mobile client, this meant *unusable* delays. Attempting to open a single email from a push notification takes more than 60 seconds. I worked around this for a while, but this degree of unresponsiveness bothered me enough that I needed to build a solution or jump ship. 

So here's my solution:

## Our Design Considerations

Before we can start building a solution, we need to write down exactly what our design constraints are. A few are imposed by ProtonMail, some are self-imposed. 

1. All filtering of incoming mail must be done with Sieve; and it must use only those extensions ProtonMail supports. 
2. We have to preserve all mail that isn't spam. That doesn't necessarily mean keeping it in our ProtonMail inbox. External backups are a valid option *if automated and 3-2-1 backed-up*.
3. Lastly, we want to multi-variably optimize for:
    - Navigability. Finding an existing email should be as quick as possible.
    - Signal-to-noise ratio. The filter structure should make it as easy as possible to notify only on emails we want to be notified of. 
    - Extensibility. As life goes on, our workflow should adapt to new needs as simply as possible. 

With those in mind, we can begin writing our scripts.

## Top-level Categorization

Because I aggregate email from multiple addresses, including from more than one active email provider (ProtonMail, Gmail), I started with a domain-and-address-based hierarchical structure: top-level folders for Gmail.com, Jafner.dev, Jafner.net, and ProtonMail; and then second-level folders for each address. Each of these is *mostly* mutually exclusive\* so it'll do fine for now. 

> *Mostly mutually exclusive*
> Technically since we check the "To:", "Cc:", and "Bcc:" fields when we filter by receiving address, we could technically end up in a situation where an email was sent "To:" one address *and* "Cc:" another, in which case our script would file that mail under the *last* (lowest listed in the script) directory. Perhaps not our preferred behavior.

Alright, so here the rubber meets the digital paper. Sieve feels pretty archaic to a guy like me. So we'll start from the result and work backwards.

[`categorize-by-receiver.sieve`](./categorize-by-receiver.sieve)

We can break this down into three chunks:

### `require`: Assert our required extensions
```sieve
require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest", "fileinto", "imap4flags"];
```

This block is pretty trivial. We make a list of [sieve extensions](https://www.iana.org/assignments/sieve-extensions/sieve-extensions.xhtml) that we use in the script. Just like you might do in any other package-managed language, but without any fancy features like namespace scoping. 

As far as I've been able to determine, there is no trivial way to derive what extension provides an action or test. 

### Don't bother running the script against spam
```sieve
# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") {
    return;
}
```

This block is kindly provided as part of ProtonMail's default script template. The `return` action halts processing of *that email* with *that filter*. Neat.

### `if <test> { <action>; }` 
```sieve
if allof (address :all :comparator "i;unicode-casemap" :matches ["To", "Cc", "Bcc"] "jafner425*@gmail.com") {
    fileinto "Gmail.com/jafner425@gmail.com";
}
```

The syntax smells of mildew and yellowed papers stuffed into dust-blanketed filing cabinets. Let's peel the creaky pages apart and understand what each thing does. We'll look at the logic structure first, then the action definition, then the test. Ascending complexity

Our outermost structure is the `condition -> action` shape. In Sieve, we can start with a good old-fashioned `if`, followed by a boolean test. If the test returns `true`, we do the action(s) wrapped in the curly-braces `{ ... }`. 

The action we want to take, move the mail to a folder, is provided by the `fileinto` extension. Astoundingly, this extension is associated with [four](https://www.rfc-editor.org/rfc/rfc5228.html) [separate](https://www.rfc-editor.org/rfc/rfc5490.html) [RFC](https://www.rfc-editor.org/rfc/rfc3894.html) [documents](https://www.rfc-editor.org/rfc/rfc5232.html). All it does for us is take one argument, the folder into which we want to file the mail, and then it moves the mail into that folder. 

Except here we encounter simplicity-induced-complexity: `fileinto` doesn't know the difference between folders and labels, and it handles responsibilities for both. So before we run the script, we have to create the folders and labels we intend to use. I do not know what the default behavior is if we run `fileinto` with a path that doesn't yet exist. Interesting space to explore. 

Email folders are organized hierarchically like a traditional filesystem, and we must specify the "absolute" path of the folder into which we want to file it. Each action is terminated by a semi-colon, very fashionable at the time. So our action ends up looking like `fileinto "Mydomain.biz/my.name@mydomain.biz";` Awesome.

So how do we match the reciver address? The `allof ( <test(s)> )` structure returns `true` if (wait for it) *all of* the tests in the parentheses return true. The rest is ugly though. 

`address :all :comparator "i;unicode-casemap" :matches ["To", "Cc", "Bcc"] "jafner425*@gmail.com"`

In order to understand this, I had to refer to the [RFC 5228](https://www.rfc-editor.org/rfc/rfc5228.html) Sieve base specification. Section `5.1` describes the usage of this test:

```
Usage:  address [COMPARATOR] [ADDRESS-PART] [MATCH-TYPE]
        <header-list: string-list> <key-list: string-list>
```

So to break down our test:

- `address` is our test, basically a function to which we pass a bunch of arguments, some of which have their own sub-arguments. 
- `:all` explicitly runs our test against the entire address (which is the default behavior), as opposed to only the local part (`jafner425`), or only the domain (`gmail.com`). 
- `:comparator "i;unicode-casemap"` tells our test to use the comparator called `"i;unicode-casemap"`, which is defined in [RFC 5051](https://www.rfc-editor.org/rfc/rfc5051.html) as "a simple case-
   insensitive collation for Unicode strings." 
- `:matches` is our "match type", and could have been `:is` or `:contains`. The latter two intuitively represent equality or substring matches, respectively. Our `:matches` type supports wildcards with `*` and `?` for "any zero or more" and "any one" characters, respectively. Note that what constitutes a "character" is determined by our comparator (`"i;unicode-casemap"`). 
- `["To", "Cc", "Bcc"]` is a list of headers whose values we should take for comparison.
- `"jafner425*@gmail.com"` is the string to which we're comparing the values of our headers. Because I know I occasionally receive email at an aliased address (e.g. `jafner425+example@gmail.com`), a naive `:is` matcher would miss those emails. 

And with that, let's look at the full statement again.

```sieve
address  <-- Our test; a function which returns a boolean
  :all <-- Say we want to consider the full address
  :comparator "i;unicode-casemap" <-- Compare each character as a case-insensitive unicode char
  :matches <-- We want to compare our email's value to the test value with wildcards
  ["To", "Cc", "Bcc"] <-- Our list of fields to check against the test string
  "jafner425*@gmail.com" <-- Our test string
```

Once you blow the cobwebs off the syntax, Sieve isn't too hard to work with. 

## Label by Date
> [RFC 5260 - Sieve Email Filtering: Date and Index Extensions](https://www.rfc-editor.org/rfc/rfc5260.html)

```sieve
Usage:  date [<":zone" <time-zone: string>> / ":originalzone"]
        [COMPARATOR] [MATCH-TYPE] <header-name: string>
        <date-part: string> <key-list: string-list>
```

```sieve
if <test> { fileinto "2024"; return; }
``` 

```sieve
date <-- Test.
  :originalzone <-- Flag to say we want to use the original timezone of the mail.
  :value "eq" <-- Our match type (via RFC 5231 "Relational") and the relational matcher for equals.
                | This match type implies the "i;ascii-numeric" comparator.
  "date" <-- Our header name to test
  "year" <-- The "date-part" (like a substring for the date datatype) we want to use.
  "2024" <-- The value to compare against.
```

And if we generalize this across multiple years, we end up with:

```sieve
if date :originalzone :value "eq" "date" "year" "2024" {  fileinto "2024"; }
if date :originalzone :value "eq" "date" "year" "2023" {  fileinto "2023"; }
if date :originalzone :value "eq" "date" "year" "2022" {  fileinto "2022"; }
if date :originalzone :value "eq" "date" "year" "2021" {  fileinto "2021"; }
if date :originalzone :value "eq" "date" "year" "2020" {  fileinto "2020"; }
if date :originalzone :value "lt" "date" "year" "2020" {  fileinto "Archive"; }
```

Well that wasn't so bad! Note that the "fileinto" actions will fail if there is no existing label or folder matching that name. 

Just gotta make sure we differentiate the Archive folder from the per-year labels. [This thread](https://www.reddit.com/r/ProtonMail/comments/112z9xb/sieve_filters_are_labels_and_folders_the_same/) offers a little insight into... how poorly documented the issue is. Fret not, Proton open-sources most of their tooling, so we can just look at [ProtonMail/libsieve-php:/lib/extensions/fileinto.xml](https://github.com/ProtonMail/libsieve-php/blob/99611bc4e3d2c0c76d803578bac4cfb80d0c3a38/lib/extensions/fileinto.xml#L6)

```php
<command name="fileinto">
  <parameter type="string" name="folder" />
</command>
```

Welp, that's a pretty good partial answer. So where do we differentiate between labels and folders? Maybe the contents of [ProtonMail/WebClients:/applications/mail](https://github.com/ProtonMail/WebClients/tree/main/applications/mail) can help us. 

Sure enough, it seems that [applications/mail/src/app/helpers/labels.ts](https://github.com/ProtonMail/WebClients/blob/main/applications/mail/src/app/helpers/labels.ts) describes the relevant logic... if only I knew TypeScript.


# Resources
- [ProtonMail Docs - How to use email filters](https://proton.me/support/email-inbox-filters)
- [ProtonMail Docs - Sieve filter (advanced custom filters)](https://proton.me/support/sieve-advanced-custom-filters)
    - Highlight: [List of supported actions and tests](https://proton.me/support/sieve-advanced-custom-filters#supported-actions-tests)
- [Github - ProtonMail/libsieve-php](https://github.com/ProtonMail/libsieve-php)
- [Fastmail - Sieve Tester](https://app.fastmail.com/sievetester/)
- [VSCode Extension - adzero/vscode-sievehighlight](https://marketplace.visualstudio.com/items?itemName=adzero.vscode-sievehighlight)
- [Sieve.info - Sieve Documents and Specifications](http://sieve.info/documents)
- [IANA.org - Sieve Extensions](https://www.iana.org/assignments/sieve-extensions/sieve-extensions.xhtml)
    - [RFC 5228 - Sieve base specification](https://www.rfc-editor.org/rfc/rfc5228.html)
    - [RFC 5490 - Extensions for checking mailbox status and accessing mailbox metadata](https://www.rfc-editor.org/rfc/rfc5490.html)
    - [RFC 3894 - Copying without side effects](https://www.rfc-editor.org/rfc/rfc3894.html)
    - [RFC 5232 - Imap4flags extension](https://www.rfc-editor.org/rfc/rfc5232.html)
    - [RFC 5231 - Relational extension](https://www.rfc-editor.org/rfc/rfc5231.html)
- [Wikipedia - Sieve (mail filtering language)](https://en.wikipedia.org/wiki/Sieve_%28mail_filtering_language%29)

