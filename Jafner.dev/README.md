# Running local dev server
1. Ensure theme submodule is loaded: `git submodule init && git submodule update`
2. Run the server with `hugo server --buildDrafts --disableFastRender`

## Including Images in Content
1. Place the image file beside the content in the folder.
2. For a Featured Image, use the line `featured_image = "../pamidi.jpg"` in the frontmatter.
3. For an inline image, use `{{< image src="../pamidi.jpg" >}}`

> Note: The working directory for relative resource locations uses the name of the content file as the current location. E.g. referencing the image `./myimage.jpg` or `./myimage.jpg` from inside the `/content/projects/pamidi.md` content file, would look for those images at `/content/projects/pamidi/myimage.jpg`. 