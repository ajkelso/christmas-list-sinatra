stephen = User.create(name: "Stephen", username: "StevieJones", email: "Stevo@jones.com", password: "pw")

cooper = User.create(name: "Cooper Doc", username: "CoopaLoop", email: "coop@doc.com", password: "pw")

s_list = List.create(name: "My most wanted", user_id: stephen.id)
c_list = List.create(name: "The greatest stuff", user_id: cooper.id)

Item.create(name: "xbox", price: 299, ranking: 10, list_id: c_list.id)
Item.create(name: "hoodie", price: 30, ranking: 2, list_id: c_list.id)
Item.create(name: "tv", price: 500, ranking: 7, list_id: c_list.id)
Item.create(name: "iphone", price: 500, ranking: 10, list_id: s_list.id)
Item.create(name: "computer", price: 1200, ranking: 10, list_id: s_list.id)
Item.create(name: "jacket", price: 80, ranking: 6, list_id: s_list.id)