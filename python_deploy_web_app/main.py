import paramiko

def deploy_web_app(server_ip, username, password, local_path, remote_path):
    try:
        # Create an SSH client
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Connect to the server
        ssh.connect(server_ip, username=username, password=password)

        # Create an SFTP client for file transfer
        sftp = ssh.open_sftp()

        # Upload local files to remote server
        sftp.put(local_path, remote_path)

        # Execute deployment commands
        commands = [
            f"cd {remote_path}",
            "docker-compose down",
            "docker-compose up -d"
        ]
        
        for cmd in commands:
            stdin, stdout, stderr = ssh.exec_command(cmd)
            print(stdout.read().decode())
            print(stderr.read().decode())

        # Close the SFTP and SSH connections
        sftp.close()
        ssh.close()

        print("Deployment successful!")
    except Exception as e:
        print(f"Deployment failed: {e}")

if __name__ == "__main__":
    server_ip = "your_server_ip"
    username = "your_username"
    password = "your_password"
    local_path = "path/to/local/files"
    remote_path = "path/on/remote/server"

    deploy_web_app(server_ip, username, password, local_path, remote_path)
