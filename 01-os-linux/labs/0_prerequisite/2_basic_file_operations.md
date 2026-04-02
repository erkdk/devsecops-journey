### Problem: 
- Be comfortable with basic operations like creating, editing, copying, moving, viewing files using Linux commands, and using command-line techniques like redirection or pipes or
searching for a string in the output.

#### Solution:
- Create a file named: ``file1.txt``
```
erkdk@my-lab:~$ touch file1.txt

erkdk@my-lab:~$ ls
file1.txt

erkdk@my-lab:~$ ls -l
-rw-rw-r--  1 erkdk erkdk    0 Apr  2 05:50 file1.txt
```

- Edit ``file1.txt``
```
erkdk@my-lab:~$ nano file1.txt 
```

- View contents of ``file1.txt``
```
erkdk@my-lab:~$ cat file1.txt 
This is my first file.
```

- Copy
``` 
erkdk@my-lab:~$ cp file1.txt file2.txt 
erkdk@my-lab:~$ ls
file1.txt  file2.txt
erkdk@my-lab:~$ ls -l
-rw-rw-r--  1 erkdk erkdk   23 Apr  2 05:51 file1.txt
-rw-rw-r--  1 erkdk erkdk   23 Apr  2 05:52 file2.txt
```

- Rename
```
erkdk@my-lab:~$ mv file2.txt newfile.txt
erkdk@my-lab:~$ ls
devops-journey  file1.txt  newfile.txt
```
- Delete
```
erkdk@my-lab:~$ rm newfile.txt
erkdk@my-lab:~$ ls
devops-journey  file1.txt
erkdk@my-lab:~$ 
```
---

- Redirect [``>`` (saves output into file)]
```
erkdk@my-lab:~$ ls > output.txt

erkdk@my-lab:~$ ls
devops-journey  file1.txt  output.txt

erkdk@my-lab:~$ cat output.txt
devops-journey
file1.txt
output.txt
erkdk@my-lab:~$

erkdk@my-lab:~$ cat <output.txt 
devops-journey
file1.txt
output.txt
erkdk@my-lab:~$
```

- Bash Redirection Operators:

| Operator | Action | Behavior |
| :--- | :--- | :--- |
| `>` | Redirect stdout | Overwrites the file if it exists. |
| `>>` | Append stdout | Adds to the end of the file. |
| `2>` | Redirect stderr | Captures only error messages. |
| `&>` | Redirect All | Captures both stdout and stderr. |
| `<` | Redirect stdin | Uses a file's content as input for a command. |

- Pipe ( | ) 
```
erkdk@my-lab:~$ ls | grep hello         (Takes output of ls and gives it to grep)
hello.c
erkdk@my-lab:~$
```
- Search Text
```
erkdk@my-lab:~$ cat hello.c | grep printf
	printf("Hello, OS Lab!\n");
erkdk@my-lab:~$ 
```
---
