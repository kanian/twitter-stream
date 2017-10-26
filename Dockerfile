FROM microsoft/dotnet:sdk AS build-env
# WORKDIR /app

LABEL Author = "Patrick Assoa Adou"
LABEL Email = "kanian77@gmail.com"

# Make sure we have S3 & additional libraries
RUN apt-get update -qq \
	&& apt-get install -y git \
	#&& mkdir /tmp/emitter \
	#&& cd /tmp/emitter \
	&& git clone "https://github.com/kanian/twitter-stream.git" "/tmp/emitter" 
	#&& cd /tmp/emitter \

WORKDIR /tmp/emitter/src/Server 

COPY *.csproj ./

RUN  dotnet restore
# Copy everything else and build
COPY . ./ 

RUN dotnet publish -c Release -o out \
    && rm -rf /tmp/emitter

# build runtime image
FROM microsoft/dotnet:runtime
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT ["dotnet", "Server.dll"]

# Application will be in app folder
WORKDIR /app
ADD deploy.sh /
CMD ["/bin/bash", "/deploy.sh"]