tests-as yet unclassified
testDeliverGroup

	| route message group |
	worker smscDatabase
		insertShortMessage: SMPPMessageTest new exampleDeliverSM messageType: '123' destination: '1234567890' source: '1234' deliverIn: 0 seconds expireIn: 10 days receivedOn: 'link1'.

	"Add routes"
	worker omDatabase
		createOrUpdateDeliveryRoute: (ShortMessageDeliveryRoute new
												routeName: 'r1';
												destinationAddressPrefix: '12345';
												addMethod: (ShortMessageDeliveryMethodTest new
													beSuccessful;
													yourself);
												yourself).

	route := (worker omDatabase collectionForDeliveryRoute select: [:each | ]) first.
	message := (worker smscDatabase collectionForSms select: [:each | ]) first.
	group := ShortMessageDeliveryGroup new
					route: route;
					add: message;
					yourself. 

	worker deliverGroup: group.

	self assert: worker smscDatabase collectionForSms size equals: 0.
	self assert: group messages size equals: 0. 