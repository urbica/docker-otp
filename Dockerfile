FROM adoptopenjdk/openjdk11:jre-11.0.13_8-alpine
LABEL authors="Stepan Kuzmin <to.stepan.kuzmin@gmail.com>, Sandeep Pandey <spandey.ike@gmail.com, Tariq Baig-Meininghaus tarbaig@gmail.com"

ENV OTP_VERSION=2.0.0
ENV JAVA_OPTIONS=-Xmx2G

ADD https://repo1.maven.org/maven2/org/opentripplanner/otp/$OTP_VERSION/otp-$OTP_VERSION-shaded.jar /usr/local/share/java/

RUN ln -s otp-$OTP_VERSION-shaded.jar /usr/local/share/java/otp.jar

COPY otp /usr/local/bin/

EXPOSE 8080

ENTRYPOINT ["otp"]
CMD ["--help"]