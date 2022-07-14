# Localize postgres for de_DE with UTF-8

FROM postgres:14
RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
ENV LANG de_DE.utf8