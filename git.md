sudo apt-get install git

1.为Git创建全局name和全局email:
$git config --global user.name "simon"
$git config --global user.email "tong.xm520@gmail.com"

2.打开terminal，判断是否有ssh软件

3.用ssh-keygen命令在个人文件夹下生成公钥密钥:
$cd ~/ && ssh-keygen -t rsa -C "tong.xm520@gmail.com"
按3个回车，密码为空。


$ cd .ssh
$ ls
id_rsa  id_rsa.pub  known_hosts


4.Copy the SSH key to your clipboard.
$ sudo apt-get install xclip
# Downloads and installs xclip. If you don't have `apt-get`, you might need to use another installer (like `yum`)

$ xclip -sel clip < ~/.ssh/id_rsa.pub
# Copies the contents of the id_rsa.pub file to your clipboard

Settings=>SSH and GPG keys=>New SSH key=>Add SSH key       
###########################################################
https://help.github.com/articles/connecting-to-github-with-ssh/
https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
###########################################################


wonder已经存在，获取源码:
$git clone git@github.com:tongxm520/wonder.git
#修改wonder下的文件
$git add .
$git commit -a -m "comment"
$git push origin master
###########################################################

-----------------------------------------------------------------
Create a new repository

cd Depot
git init
git remote add origin git@github.com:tongxm520/Depot.git
git add .
git commit -a -m "all"
git push origin master

#####################################################################
git remote add origin git@github.com:tongxm520/schoolify.git==>
ERROR: Repository not found.
fatal: Could not read from remote repository.
Please make sure you have the correct access rights
and the repository exists.
#####################################################################
Had similar issue. The root of the problem was that I followed some online tutorial about adding a new repository to Github.

##Just go to Github, create a new repo, it will ask you to add a README, don't add it. Create it, and you'll get instructions on how to push.
##It's similar to the next two lines:
##git remote add origin git@github.com:tongxm520/schoolify.git
##git push -u origin master

----------------------------------------------------------------------
create a new repository on the command line
echo "# schoolify" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:tongxm520/schoolify.git
git push -u origin master

----------------------------------------------------------------------
push an existing repository from the command line
git remote add origin git@github.com:tongxm520/schoolify.git
git push -u origin master



