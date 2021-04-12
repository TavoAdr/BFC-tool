# About the Project

The File Creation Management Tool in Bash or just FCM-tool is a simple tool made in Shell Script (focused on linux) that can help you create several files in any folder and with the possibility of having several different extensions or sharing the same .

# How to Use

To use this tool, you just need to run the FCM-tool.sh on your terminal (with bash) and give a name to the directory it needs to be executed in (following it like any other terminal command or type it after running) and ask the question about the program files.

## Step by Step

To run FCM-tool.sh, you must allow the main file (FCM-tool.sh) to run, which can be done through your file manager's permission settings or by the command `chmod a+x FCM -tool.sh` so that all users can run it or `chmod u+x FCM-tool.sh` so that only you can run it.

After that, you can run the program in two ways, the first one by calling its path and program name from the terminal (`path/FCM-toll.sh`) or clicking on run, via the file manager and the second called one folder next to your path (only in the terminal), with the difference of these two cases the possibility of using variables and others like `~`, `./` and `../` to call the directory in the second case, while in the first case, you must pass the full path or at most `./` and `../`, but the use of ~ and global variables will not be possible.

**Never call directories with spaces in their name, this can cause errors during the execution of the program.**

Once it has been indicated and validated which folder will be the main one (folder in which the program will be executed and generally, which will contain the other folders or files), one must choose whether the files will be arranged in a single folder or in multiple folders.

### Single Folder

This method causes the files to be created directly in the main folder, and can have several if they have a different extension, but never two identical ones.

After selecting the method, you will be asked for the names of the files and their extensions and given the option to fill in a text, for each type of extension, so that this text appears in all files of this extension and finally the files will be created as specified.

### Multiple Folders

The possibility of creating files in multiple folders causes the same files to be created and several different folders, being able to select a method in which the file will be divided among the folders, according to their station, such as files for the folders of txt extension texts and shell files, in the bash folder of extension sh, or all files, regardless of their extension, in all folders, which generates the text article.txt, writing.txt and the pdf job.pdf in folder pupil1 and pupil2.

The method that separates folders by extension, makes it necessary to have the same number of extensions and folders, this being its only limitation.

After selecting the method, as mentioned in the example of the single folder, you will be asked for the names of the files and their extensions and you will have the option to fill in a text, for each type of extension, so that this text appears in all files of this extension and finally the files will be created as specified.
