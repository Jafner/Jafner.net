{ ... }: {
  resource.local_file.test = {
    filename = "some-file.txt";
    content = "Hello, World!";
  };
}
