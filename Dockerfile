FROM python:3

WORKDIR /usr/src/app

COPY . .
RUN apt update && \
apt upgrade -y && \
apt install -y ca-certificates ffmpeg && \
wget --no-check-certificate -c https://www.geotrust.com/resources/root_certificates/certificates/GeoTrust_Global_CA.pem  && \
mkdir /usr/local/share/ca-certificates/extra && \
mv GeoTrust_Global_CA.pem /usr/local/share/ca-certificates/extra/GeoTrust_Global_CA.crt && \
update-ca-certificates && \
pip install --no-cache-dir -r requirements.txt

CMD ["python", "-u", "./download_all.py", "--directory", "/videos"]