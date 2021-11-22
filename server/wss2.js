const WebSocket = require('ws');
 
const wss = new WebSocket.Server({ port: 6628 });
console.log('ready on 6628');
 
wss.on('connection', function connection(ws) {
	console.log('inc conn ', ws);
  ws.on('message', function incoming(data) {
	console.log('inc msg with data ', data);
    
	wss.clients.forEach(function each(client) {
		//console.log('sending ', data,'to', client);	
      if (client.readyState === WebSocket.OPEN) { //client !== ws && 
        client.send(data);
		console.log('sent data to client');	
      } else {
		console.log('NOT send to', client, 'becouse', client.readyState);	
	  }
    });
  });
});
