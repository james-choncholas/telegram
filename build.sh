#!/bin/bash

set -e

# create a base docker image with no login info
sudo docker build \
    -t telegram-base \
    .

if [[ "$(sudo docker ps -a | grep telegram-customized)" != "" ]]; then
    echo deleting temerary image telegram-customized
    sudo docker rm telegram-customized
fi

echo -e "\n\n\n\nGive telegram your phone number (prepend 1 for USA) and enter code"
echo -e "then press <C+C> <CR> to exit and save\n\n\n"
sudo docker run -it --name="telegram-customized" telegram-base /home/anon/tg/bin/telegram-cli

while true; do
    read -p "Save configuration? [y/n] : " yn
    case $yn in
        [Yy]* )
            if [[ "$(sudo docker images -q telegram:latest 2> /dev/null)" != "" ]]; then
                echo deleting old telegram image
                sudo docker rmi telegram
            fi

            # need to set the entrypoint back to entry script.
            sudo docker commit --change='ENTRYPOINT ["telegram.sh"]' telegram-customized telegram
			break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo -e "\n\n\nDeleting temperary image telegram-customized"
sudo docker rm telegram-customized

