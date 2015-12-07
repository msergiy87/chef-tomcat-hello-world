# chef-tomcat-hello-world
1) Create chef-repo on your chef Workstation and put files and dirs to the 'chef-repo/cookbooks/tomcat' directory

2) Add 'apt' cookbook
```
knife cookbook site download apt
knife cookbook site install apt 2.9.2
```

3) Upload code to the Chef Server and Bootstrap your clent machine
```
knife cookbook upload -a
cd ~/Desktop/chef/chef-repo
knife bootstrap 192.168.0.102 -N testing8 -x sergiy -P 837611 --sudo --use-sudo-password
```

4) Edit Run List
```
export EDITOR=vim
knife node edit testing8
  "run_list": [
  "recipe[apt]",
  "recipe[tomcat]"
]
```

5) Run 'sudo chef-client' on the clent machine
