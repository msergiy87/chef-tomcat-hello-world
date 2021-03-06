#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install Java + Apapche Tomcat + Hello World
# http://192.168.0.102:8080/hello/sayhello

# Update package list
#execute "apt-get update" do
#  command "apt-get update"
#end

# Install Java
package 'default-jdk' do
  action :install
end

# Create Tomcat User
user 'tomcat' do
  action :create
  comment 'A tomcat user'
  home '/opt/tomcat'
  shell '/bin/false'
end

group 'tomcat' do
  action :create
  members 'tomcat'
  append false
end

# Install Tomcat
remote_file '/home/apache-tomcat-8.0.29.tar.gz' do
  source 'http://apache.volia.net/tomcat/tomcat-8/v8.0.29/bin/apache-tomcat-8.0.29.tar.gz'
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

directory '/opt/tomcat' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute "extract archeve to /opt/tomcat" do
  command "tar xvf /home/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1"
end

directory '/opt/tomcat/conf' do
  mode '0775'
end

execute "manage permissions conf" do
  command "chgrp -R tomcat /opt/tomcat/conf && chmod g+r /opt/tomcat/conf/*"
end

#directory '/opt/tomcat/conf/' do
#  group 'tomcat'
#  recursive true
#  action :create
#end

execute 'chown some files: work, temp, logs' do
  command 'chown -R tomcat /opt/tomcat/work /opt/tomcat/temp /opt/tomcat/logs'
end

cookbook_file "/etc/init/tomcat.conf" do
  source "tomcat.conf"
  mode "0644"
end

execute 'start tomcat service' do
  command 'initctl reload-configuration && initctl start tomcat'
  not_if '/sbin/initctl status tomcat | /bin/grep running'
end

# Configure "Hello-world" Java Servlet
%w[ /opt/tomcat/webapps/hello /opt/tomcat/webapps/hello/WEB-INF /opt/tomcat/webapps/hello/WEB-INF/classes ].each do |path|
  directory path do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

cookbook_file "/opt/tomcat/webapps/hello/WEB-INF/classes/HelloServlet.java" do
  source "HelloServlet.java"
  mode "0644"
end

execute 'Compiling the Servlet' do
  command 'javac -cp /opt/tomcat/lib/servlet-api.jar HelloServlet.java'
  cwd '/opt/tomcat/webapps/hello/WEB-INF/classes'
end

cookbook_file "/opt/tomcat/webapps/hello/WEB-INF/web.xml" do
  source "web.xml"
  mode "0644"
end
