# WriteDirectoryContents

This program creates a TXT file that reflects all files and folders under the specified root directory in a nested structure. Indentation is used for nested folders.

## How does it work:
The SaveDirectoryTreeToFile procedure runs with the specified root directory and output filename.

The WriteDirectoryContents procedure is called recursively. This procedure scans the files and subfolders for each folder, prints them via StreamWriter.
Files and folders are indented so that the folder hierarchy is preserved.


## Test
After building the application;

```bash
WriteDirectoryContents.exe run the application by double-clicking
```

```bash
Console:
    cmd> WriteDirectoryContents.exe
    cmd> WriteDirectoryContents.exe -c (It also writes the results to the console)
```

Writes the results to ```WriteDirectoryContents.txt``` file

### Results (WriteDirectoryContents.txt)
```sh
[root]
 ├── .gitignore
 ├── LICENSE
 ├── README.md
 ├── [TEST1]
 │    ├── test1.file
 │    ├── [SUB-TEST1]
 │    │    ├── subtest1_1.file
 │    │    ├── subtest1_2.file
 │    │    └── subtest1_3.file
 │    ├── [SUB-TEST2]
 │    │    └── subtest2_1.file
 ├── [TEST2]
 │    ├── test2_1.file
 │    ├── test2_2.file
 │    └── test2_3.file
 └── [TEST3]
```


