解压安装：
tar zxvf ruby-2.2.5.tar.gz
./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
make
sudo make install
ruby -v 

sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool  libmysqlclient-dev  
sudo apt-get install -y curl libcurl3-dev git
sudo apt-get install libmysql-ruby

在ruby的目录ext下，需要安装一下openssl。
$ cd ruby解压安装目录/ext/openssl
$ ruby extconf.rb
$ make
No rule to make target `/include/ruby.h', needed by `ossl_ns_spki.o'
#######################################################
Add this to your Makefile in ../ext/openssl (after using ruby extconf.rb):
top_srcdir = ../..  after archdir = $(rubyarchdir)
#######################################################
$ sudo make install
/usr/bin/install -c -m 0755 openssl.so /usr/local/lib/ruby/site_ruby/2.2.0/i686-linux
installing default openssl libraries

当安装gem包时，报zlib的load error，请重新进入ruby的zlib目录下重新安装。（方法同安装openssl）
$ cd ruby解压安装目录/ext/zlib
$ ruby extconf.rb
$ make
$ sudo make install

gem install rails -v=3.2.22

>mysql安装
http://dev.mysql.com/downloads/mysql/#downloads
mysql-5.7.16-linux-glibc2.5-i686.tar.gz

首先添加mysql用户组
simon@localhost$ groupadd mysql

添加mysql用户，并指定到mysql用户组
simon@localhost$ useradd -g mysql mysql

解压缩mysql-5.7.16-linux-glibc2.5-i686.tar.gz到安装目录(/usr/local/)
simon@localhost$ cd /usr/local
simon@localhost$ sudo tar zxvf /home/simon/Downloads/mysql-5.7.16-linux-glibc2.5-i686.tar.gz
simon@localhost$ ls

创建mysql软连接mysql-VERSION-OS
simon@localhost$ sudo ln -s /usr/local/mysql-5.7.16-linux-glibc2.5-i686 mysql
simon@localhost$ cd mysql
simon@localhost$ ls

设定mysql安装目录权限，设置owner为mysql
simon@localhost$ sudo chown -R mysql .
simon@localhost$ sudo chgrp -R mysql .

执行mysql系统数据库初始化脚本
sudo bin/mysql_install_db --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data 
提示mysql_install_db 命令已弃用，使用mysqld 
sudo bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data  

设定data目录权限，分配给mysql用户，为了mysql程序能读写data目录下的文件
simon@localhost$ sudo chown -R root .
simon@localhost$ sudo chown -R mysql data 

使用mysql帐号启动mysql应用
simon@localhost$ sudo bin/mysqld_safe --user=mysql & 
cannot create /var/lib/mysql/mysqld_safe.pid: Directory nonexistent
cannot touch ‘/var/log/mysql/error.log’: No such file or directory

sudo mkdir /var/lib/mysql
sudo mkdir /var/log/mysql
sudo mkdir /var/run/mysql

/var/run/mysqld/mysqld.pid ended

设置root密码
A temporary password is generated for root@localhost: :vqfNRw&9h_E

simon@localhost$ sudo bin/mysqladmin -u root password '123456'
mysql>SET PASSWORD FOR 'root'@'localhost' = PASSWORD('123456'); 

登录mysql
simon@localhost$ bin/mysql -u root -p  

【MySQL】查看MySQL配置文件路径及相关配置 
$ which mysqld
/usr/sbin/mysqld
$ /usr/sbin/mysqld --verbose --help | grep -A 1 'Default options'
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
服务器首先会读取/etc/my.cnf文件，如果发现该文件不存在，再依次尝试从后面的几个路径进行读取。

cd ~/
sudo find / -name "my.cnf" -type f


>The server quit without updating PID file (/usr/local/mysql/data/ubuntu.pid).
Solution 2: Remove Your MySQL Config File
If you have modified your MySQL configuration file, MySQL may not like it few versions after (MySQL is not backward compatibility friendly). It can be the problem of using an unsupported variable, or something similar. The easiest way is to remove your configuration file, and try to start the MySQL server again

Backup your MySQL configuration first.
mv /etc/mysql/my.cnf /etc/mysql/my.cnf.backup 


cd /usr/local/mysql
sudo chmod -R 777 data
启动mysql
mysqld --defaults-file=/home/simon/Desktop/Depot/config/my.cnf
mysqld_safe --defaults-file=/home/simon/Desktop/Depot/config/my.cnf --user=mysql &



`require': cannot load such file -- readline (LoadError)
$ cd ruby解压安装目录/ext/readline
$ ruby extconf.rb
$ make
No rule to make target `/include/ruby.h', needed by `readline.o'.
#######################################################
Add this to your Makefile in ../ext/openssl (after using ruby extconf.rb):
top_srcdir = ../..  after archdir = $(rubyarchdir)
#######################################################
$ sudo make install

There was an error while trying to load the gem 'coffee-rails'. (Bundler::GemRequireError)
原因是缺少依赖的组件nodejs
运行sudo apt-get install nodejs 安装nodejs，再重新运行rails c即可。


在Depot外面找
sudo find / -name "*.rb"|xargs grep 'last_comment'

rails runner script/load_orders.rb

#############################################################
电子商务系统
restful API
问卷调查系统
考试系统
文档管理系统
爬虫系统
#############################################################

百度: online learning website
#############################################################
cd /usr/local/mysql/
sudo ./support-files/mysql.server start

##mysqld_safe --defaults-file=/home/simon/Desktop/Depot/config/my.cnf --user=mysql &

##mysqld_safe --defaults-file=/etc/mysql/my.cnf --user=mysql &

##warning: World-writable config file /home/simon/Desktop/Depot/config/my.cnf is ignored
cd /home/simon/Desktop/Depot/config
ll
-rwxrwxrwx  1 root  root  1299 Nov 13  2016 my.cnf

If the first part of the line looks like "-rw-rw-rw-" or "rwxrwxrwx", the file's permissions are "World-writable".
To fix this problem, use the following command to change file's permissions

sudo chmod 644 /home/simon/Desktop/Depot/config/my.cnf
-rw-r--r--  1 root  root  1299 Nov 13  2016 my.cnf

##mysql auto start on ubuntu
1、cp /usr/local/MySQL/support-files/mysql.server /etc/init.d/mysql   将服务文件拷贝到init.d下，并重命名为mysql
2、chmod +x /etc/init.d/mysql    赋予可执行权限
3、chkconfig --add mysql        添加服务
4、chkconfig --list             显示服务列表
如果看到mysql的服务，并且3,4,5都是on的话则成功，如果是off，则键入
chkconfig --level 345 mysql on
5、reboot重启电脑
6、netstat -na | grep 3306，如果看到有监听说明服务启动了


###########################################################
You should try hirb. It's a gem made to to pretty format objects in the ruby console. 
>> require 'hirb'
=> true
>> Hirb.enable
=> true
>> ProductColor.first
+----+-------+---------------+---------------------+---------------------+
| id | name  | internal_name | created_at          | updated_at          |
+----+-------+---------------+---------------------+---------------------+
| 1  | White | White         | 2009-06-10 04:02:44 | 2009-06-10 04:02:44 |
+----+-------+---------------+---------------------+---------------------+
1 row in set
=> true


Awesome print is nice too if you want an object indented. Something like:
$ rails console
rails> require "awesome_print"
rails> ap Account.all(:limit => 2)
[
    [0] #<Account:0x1033220b8> {
                     :id => 1,
                :user_id => 5,            
    },
    [1] #<Account:0x103321ff0> {
                     :id => 2,
                :user_id => 4,
    }
]
###########################################################
create_table :user_views do |t|
  t.integer :user_id
  t.integer :article_id
end

An easy way to do this in Rails is to use validates in your model with scoped uniqueness as follows:
validates :user, uniqueness: { scope: :article }

class AddUniqueIndexToReleases < ActiveRecord::Migration
  def change
    add_index :releases, [:country, :medium], unique: true
  end
end

class Release < ActiveRecord::Base
  validates :country, uniqueness: { scope: :medium }
end

###########################################################
btoa('hujintao2013@gmail.com');
atob('aHVqaW50YW8yMDEzQGdtYWlsLmNvbQ==');

< btoa('mailto:email@example.com')
< "bWFpbHRvOmVtYWlsQGV4YW1wbGUuY29t"

'13zaxGVjj9MNc2jyvDRhLyYpkCh323MsMq'

How to Reveal Passwords or any hidden information with asterisks in most of the pages?
=>modify type from password to text
###########################################################
text = "intérnalionálização"
 => "intérnalionálização"
text.encoding
 => #<Encoding:UTF-8>
encoded = Base64.encode64(text)
 => "aW50w6lybmFsaW9uw6FsaXphw6fDo28=\n"
encoded.encoding
 => #<Encoding:US-ASCII>
decoded = Base64.decode64(encode)
 => "int\xC3\xA9rnalion\xC3\xA1liza\xC3\xA7\xC3\xA3o"
decoded.encoding
 => #<Encoding:US-ASCII>
decoded = decoded.force_encoding('UTF-8')
 => "intérnalionálização"
decoded.encoding
 => #<Encoding:UTF-8>


