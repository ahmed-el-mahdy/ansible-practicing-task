FROM ubuntu

RUN apt-get update && \
    apt-get install ssh -y && \
    apt-get install sudo -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

    RUN useradd -m devops && \
        echo 'devops:123' | chpasswd && \
        passwd -d root && \
        usermod -aG sudo devops && \
        mkdir -p /var/run/sshd && \
        echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
        echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config


# Create a startup script    
RUN echo '#!/bin/bash\n\
    /usr/sbin/sshd\n\
    tail -f /dev/null\n\
    ' > /start.sh && chmod +x /start.sh


# Expose SSH port
EXPOSE 22

ENTRYPOINT ["/start.sh"]

