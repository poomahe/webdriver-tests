#!/bin/bash

# Function to check if given command exist !!
is_Command_Exist(){
    local arg="$1"
    type "$arg" &> /dev/null
    return $?
}

# Install Function
install_package(){
    local arg="$1"
    sudo apt install "$arg"
}

#command function
is_pkg_exist(){
        local arg="$1"
        dpkg -l | grep "$arg" &> /dev/null
        return $?
}

# Install Function
install_xvfb(){
    local arg="$1"
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$arg"
}

# Check Java exist or not?
if is_Command_Exist "java"; then
    echo "Java is installed in this ubuntu"
else
    echo "Java is not installed"
    install_package "openjdk-8-jdk";
fi

# Check Maven exist or not?
if is_Command_Exist "mvn"; then
    echo "Maven is installed in this ubuntu"
else
    echo "mvn is not installed"
    install_package "mvn";
fi

if is_pkg_exist "xvfb"; then
        echo "xvfb is installed in this ubuntu"
else
        echo "xvfb is not installed"
        install_xvfb "xvfb"
fi

#check chorme browser exist or not?
if is_pkg_exist "chrome"; then
        echo "Chrome is installed in this ubuntu"
else
        echo "Chrome is not installed"
        wget http://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.198-1_amd64.deb
        chrome_deb_file_extraction=$(sudo dpkg -i google-chrome-stable_114.0.5735.198-1_amd64.deb)
        echo "Deb file $chrome_deb_file_extraction extracted successfully"
        if is_pkg_exist "chrome"; then
                 echo "Deb file is extractd & Chrome is installed in this ubuntu"
         else
                 sudo apt --fix-broken install
                 echo "Failure is fixed & Chrome is installed finally"
        fi

#       if ($install_fails)
#       pid = $!
#       echo "Process with PID $pid is running"
#       wait -f
#       echo "Process with PI has finished with Exit Status: $?"
fi



gitdir="/home/ubuntu/webdriver-tests"

if [ -d "$gitdir" ]

then
        echo "My webdriver test folder exist, proceed with git pull"
        git pull
        mvn clean test
else
        #echo "My $gitdir Exists"
        #cd $gitdir
        echo "$gitdir folder does not exist"

fi

s3push="/home/ubuntu/webdriver-tests/reports"
if [ -d "$s3push" ]

then
        echo "My $s3push Exists"
        aws s3 sync $s3push s3://poo-reports-ubuntu

else
        echo "My webdriver reports folder not exist"

fi

