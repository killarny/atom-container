#!/bin/bash" > install_plugin.sh
URL=$@
UPDATE=$(curl -s $URL |python -c "import sys, bs4; url = bs4.BeautifulSoup(''.join([line for line in sys.stdin]), 'html5lib').find(class_='version_table').find('a', text='Download')['href']; print(url[url.rfind('=')+1:])")
wget --trust-server-names "https://plugins.jetbrains.com/plugin/download?updateId=$UPDATE"
