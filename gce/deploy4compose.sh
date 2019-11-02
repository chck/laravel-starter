MY_INSTANCE_NAME=php-sandbox
ZONE=asia-northeast1-c
MACHINE_TYPE=n1-standard-4

gcloud compute instances create $MY_INSTANCE_NAME \
    --image-family=ubuntu-1804-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=$MACHINE_TYPE \
    --scopes userinfo-email,cloud-platform \
    --metadata-from-file startup-script=startup-docker.sh \
    --zone $ZONE \
    --tags http-server,nginx

gcloud compute firewall-rules create default-allow-http-80 \
    --allow tcp:80 \
    --source-ranges 0.0.0.0/0 \
    --target-tags http-server \
    --description "Allow port 80 access to http-server"

gcloud compute firewall-rules create default-allow-nginx-8990 \
    --allow tcp:8990 \
    --source-ranges 0.0.0.0/0 \
    --target-tags nginx \
    --description "Allow port 8990 access to nginx"
