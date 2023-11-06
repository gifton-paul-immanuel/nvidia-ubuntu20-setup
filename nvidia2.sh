#!/bin/bash
echo -e "Enter the option: \n[1] Package Updater\n[2] Installing drivers, required apt packages, CUDAv12.2.1, cuDNNv8.9.3, VSCodev1.81.1, Docker, Nvidia Container Env\n[3] Install all python environments (ML,DL,OMNX,QT) and packages, Miniconda3"
read -p "Enter the option:" option

if [ "$option" -eq 1 ]; then
    if [ "$EUID" -ne 0 ]; then 
    	echo "Error: Please run as root."
    	exit
    else
    	echo "[+] Updating list of available packages..."
    	apt update
    
    	echo "[+] Upgrading the system by removing/installing/upgrading packages..."
    	apt full-upgrade --yes
    
    	echo "[+] Removing automatically all unused packages..."
    	apt autoremove --yes
    
    	echo "[+] Clearing out the local repository of retrieved package files..."
    	apt autoclean --yes

    	echo "[+] Computer will reboot now in 10 seconds"
    	sleep 10
    	reboot now
    fi

elif [ $option -eq 2 ]
then

    if [ "$EUID" -ne 0 ]
    then
        echo "Error: Please run as root."
        exit
    fi

    clear

    apt install neofetch -y
    echo "[+] System Specs"
    neofetch

    echo "[+] Installing NVIDIA Driver"
    apt install nvidia-driver-535 -y
    echo "[+] Done Installing NVIDIA Driver"


    echo "[+] Installing all apt packages"
    apt install build-essential pkg-config curl wget uget tar zip unzip rar unrar cmake cmake-qt-gui ninja-build valgrind python3 python3-wheel python3-pip python3-venv python3-dev python3-setuptools git linux-headers-$(uname -r) build-essential libgl1-mesa-dev -y
    echo "[+] Done downloading all apt packages"





    echo "[+] Installing Cudnn v8.9.3"
    server_IP=192.168.6.219
    port=8888
    cudnn_pkg=cudnn.deb
    wget http://$server_IP:$port/$cudnn_pkg
    dpkg -i cudnn.deb
    cp /var/cudnn-*/cudnn*.gpg /usr/share/keyrings/
    apt update -y
    apt install libcudnn8 libcudnn8-dev -y
    echo "[+] Done installing cudNN"


    echo "[+] Installing VScode"
    wget https://az764295.vo.msecnd.net/stable/6c3e3dba23e8fadc360aed75ce363ba185c49794/code_1.81.1-1691620686_amd64.deb -O /opt/vscode.deb
    dpkg -i /opt/vscode.deb
    echo "[+] Done installing VScode"
    

    echo "[+] Installing docker enginer, compose and also the NVIDIA Container Toolkit."
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update -y
    sudo apt-get install -y nvidia-container-toolkit
    sudo nvidia-ctk runtime configure --runtime=docker
    sudo systemctl restart docker
    echo "[+] Done Installing docker and nvidia container Toolkit"
    echo "[+] Reboot the system now !"

    echo "[+] Installing ROS Noetic"
    wget -c https://raw.githubusercontent.com/qboticslabs/ros_install_noetic/master/ros_install_noetic.sh -O /opt/ros_noetic.sh && chmod +x ./opt/ros_noetic.sh && sh /opt/ros_noetic.sh
    echo "[+] Done Installing ROS Noetic"
    
    
    echo "[+] Intalling Miniconda3"
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh
    chmod +x /opt/miniconda.sh
    ./opt/miniconda.sh
    source ~/miniconda3/bin/activate 
    conda config --set auto_activate_base false
    conda deactivate
    echo "[+] Done Installing Miniconda3"

    # echo "[+] Computer will reboot now in 10 seconds"
    # sleep 10
    # reboot now
    
    exit
    
elif [ $option -eq 3 ]
then

    if [ "$EUID" -eq 0 ]
    then
        echo "Error: Please dont run as root."
        exit
    fi

    clear

    echo "[+] Installing ML Env"
    python3 -m venv ~/venvs/ml
    source ~/venvs/ml/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade numpy scipy matplotlib ipython jupyter pandas sympy nose
    pip install --upgrade scikit-learn scikit-image
    deactivate
    echo "[+] Done installing ML Env"  

    echo "[+] Installing Deep learning Env (Tensorflow-CPU)"
    python3 -m venv ~/venvs/tfcpu
    source ~/venvs/tfcpu/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade opencv-python opencv-contrib-python
    pip install --upgrade tensorflow-cpu tensorboard keras
    deactivate    
    echo "[+] Done Installing"

    echo "[+] Installing Deep learning Env (Tensorflow-GPU)"
    python3 -m venv ~/venvs/tfgpu
    source ~/venvs/tfgpu/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade opencv-python opencv-contrib-python
    pip install --upgrade tensorflow tensorboard keras
    deactivate
    echo "[+] Done Installing"

    echo "[+] Installing Deep learning Env (PyTorch-CPU)"
    python3 -m venv ~/venvs/torchcpu
    source ~/venvs/torchcpu/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade opencv-python opencv-contrib-python
    pip install --upgrade torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
    deactivate
    echo "[+] Done Installing"

    echo "[+] Installing Deep learning Env (PyTorch-GPU)"
    python3 -m venv ~/venvs/torchgpu
    source ~/venvs/torchgpu/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade opencv-python opencv-contrib-python
    pip install --upgrade torch torchvision torchaudio
    deactivate
    echo "[+] Done Installing"

    echo "[+] Installing OMNX Runtime Environment"
    python3 -m venv ~/venvs/onnx
    source ~/venvs/onnx/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade onnx onnxruntime-gpu
    deactivate
    echo "[+] Done Installing"


    echo "[+] Installing QT Environment (Pyside)"
    python3 -m venv ~/venvs/qt
    source ~/venvs/qt/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade PySide6
    deactivate
    echo "[+] Done Installing"

    exit

else
    echo "Not a valid option !"
    exit
fi














