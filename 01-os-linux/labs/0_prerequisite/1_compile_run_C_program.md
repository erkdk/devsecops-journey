#### Problem: 
- Be comfortable with writing and compiling code on Linux.
Learn how to compile and run C programs, using a terminal
on a Linux machine. Type up your programs in the editor of your choice. Compile and run your
code from the terminal.

#### Solution:
- Create a file ``hello.c`` and write the code.
```
aadarkdk@pop-os:~$ nano hello.c

aadarkdk@pop-os:~$ cat hello.c 
#include <stdio.h>
int main(){
	printf("Hello, OS Lab!\n");
	return 0;
}

aadarkdk@pop-os:~$ ls -l
-rw-rw-r--   1 aadarkdk aadarkdk       74 Apr  2 10:55  hello.c
```

- Compile the code.
```
aadarkdk@pop-os:~$ gcc hello.c

aadarkdk@pop-os:~$ ls -l
-rwxrwxr-x   1 aadarkdk aadarkdk    15960 Apr  2 10:57  a.out
-rw-rw-r--   1 aadarkdk aadarkdk       74 Apr  2 10:55  hello.c

aadarkdk@pop-os:~$ gcc hello.c -o hello

aadarkdk@pop-os:~$ ls -l
-rwxrwxr-x   1 aadarkdk aadarkdk    15960 Apr  2 10:57  a.out
-rwxrwxr-x   1 aadarkdk aadarkdk    15960 Apr  2 10:57  hello
-rw-rw-r--   1 aadarkdk aadarkdk       74 Apr  2 10:55  hello.c
aadarkdk@pop-os:~$
``` 

- Run it to get output.
```
aadarkdk@pop-os:~$ ./hello
Hello, OS Lab!
aadarkdk@pop-os:~$ 
```
