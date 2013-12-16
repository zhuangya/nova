Test API
===

http://nova.icybear.net/


Schema
===

item (in cart): `[:categlogy]/[:name]/[:variant]/[:size]`

eg.: `tee/pure_color/white/xxl`

---------

metadata (json): `/data/[:categlogy]/[:name]`

metadata (yaml): `/data/[:categlogy]/[:name]/metadata.yml`

eg.: `/data/tee/pure_color` 

---------

picture: `/photo/[:categlogy]/[:name]/[:variant]_[:filename](?schema=[:schema])`

eg.: `/photo/tee/pure_color/white_main.jpg?schema=cover120`

---------

product
---
```
id: tees/pure_color
name: Pure Color T-Shirts
description: |
	I am a T-Shirt
	DO NOT typo as T-Shit
variants:
	white: White Tee
	black: Black Tee
price:
	white: 133.22
	black: 122.34
inventory:
	white: 
		s:0
		m:10
		l:2
		xl:20
	black:
		s:0
		m:0
		xl:10
```

cart
---
```
[
	name: tees/pure_color/white/xxl
	quantity: 1
	unit_price: 100.0
]
```


order
---
```
id: 1234567
alipay_txid: 890123456
items: 
	[<cart>]
status: processing
shipping: "123456789”
address: some where in the world
phone: 18600000000
```

API
===


GET /data/[:id]
---
get product data


GET /api/cart
---
get cart


POST /api/cart
---
add to cart


DELETE /api/cart
---
remove items from cart


POST /api/order
---
create order


GET /api/order
---
get orders of user


POST /api/authorize
---
login

