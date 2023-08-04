import boto3
import time

def create_ec2_instance(image_id, instance_type, key_name):
    ec2 = boto3.resource('ec2')

    print("Creating EC2 instance...")
    instance = ec2.create_instances(
        ImageId=image_id,
        InstanceType=instance_type,
        KeyName=key_name,
        MinCount=1,
        MaxCount=1
    )[0]

    instance.wait_until_running()

    instance.reload()
    print(f"EC2 instance created:\nID: {instance.id}\nPublic IP: {instance.public_ip_address}")

    return instance

def deploy_web_server(instance, user, key_path):
    print("Deploying web server...")

    ssh_command = (
        f"ssh -i {key_path} {user}@{instance.public_ip_address} "
        "'sudo apt-get update && "
        "sudo apt-get install -y apache2 && "
        "echo <h1>Hello from DevOps Automation!</h1> | sudo tee /var/www/html/index.html'"
    )

    import subprocess
    subprocess.run(ssh_command, shell=True)

    print("Web server deployed.")

if __name__ == "__main__":
    # AWS EC2 parameters
    image_id = 'ami-0123456789abcdef0'  # Replace with a valid AMI ID
    instance_type = 't2.micro'
    key_name = 'my-key-pair'  # Replace with your EC2 key pair name
    user = 'ubuntu'
    key_path = '/path/to/your/private/key.pem'

    # Create EC2 instance
    instance = create_ec2_instance(image_id, instance_type, key_name)

    # Deploy a basic web server on the instance
    deploy_web_server(instance, user, key_path)
