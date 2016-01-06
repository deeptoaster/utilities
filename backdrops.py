#!/usr/bin/python
import json
from PIL import Image
import urllib2

req = urllib2.Request('https://www.reddit.com/r/EarthPorn+SpacePorn/.json')
req.add_header('User-Agent', 'Paperbot/2.0')
porns = json.load(urllib2.urlopen(req))['data']['children']
for porn in porns:
	url = porn['data']['url']
	if not url.endswith(('.gif', '.jpeg', '.jpg', '.png', '.tif', '.tiff')):
		if 'imgur.com' in url:
			url = url + '.jpg'
		else:
			continue
	img = Image.open(urllib2.urlopen(url))
	w, h = img.size
	img.crop((0, 0, int(w * 0.8), int(h * 0.8))).save('/home/woot/Documents/backdrops/haut-gauche', 'PNG')
	img.crop((int(w * 0.2), 0, w, int(h * 0.8))).save('/home/woot/Documents/backdrops/haut-droite', 'PNG')
	img.crop((0, int(h * 0.2), int(w * 0.8), h)).save('/home/woot/Documents/backdrops/bas-gauche', 'PNG')
	img.crop((int(w * 0.2), int(h * 0.2), w, h)).save('/home/woot/Documents/backdrops/bas-droite', 'PNG')
	break
