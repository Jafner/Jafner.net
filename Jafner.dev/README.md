# Running local dev server
1. Ensure theme submodule is loaded: `git submodule init && git submodule update`
2. Run the server with `hugo server --noHTTPCache --ignoreCache --disableFastRender --buildDrafts`

## Including Images in Content
*Good old-fashioned `![](image.png)` markdown image embedding works just fine.*

1. Place the image file beside the content in the folder.
2. For a Featured Image, use the line `featured_image = "../pamidi.jpg"` in the frontmatter.
3. For an inline image, use `{{< image src="../pamidi.jpg" >}}`

> Note: The working directory for relative resource locations uses the name of the content file as the current location. E.g. referencing the image `./myimage.jpg` or `./myimage.jpg` from inside the `/content/projects/pamidi.md` content file, would look for those images at `/content/projects/pamidi/myimage.jpg`. 

## Add a Table of Contents
- To include a table of contents at the beginning of a page, add the flag `toc = true` to the frontmatter. 
- To insert a table of contents inline with the text, use the `{{% toc %}}` shortcode.
- Tables of contents are configured under the `[markup]` configuration node in [`config.toml`](/config.toml).

