const fs = require('fs');
const WebSocket = require('ws');
const nicksFileName = 'nicks.json';
const arTalesFileName = 'tales.json';

let oNick = {};
let arTalesToSend = [];

try { 
	oNick = JSON.parse(fs.readFileSync(nicksFileName));  
	console.log('got read nicks from file', oNick);
} catch(e) {}

try { 
	arTalesToSend = JSON.parse(fs.readFileSync(arTalesFileName));  
	console.log('got read arTalesToSend from file', arTalesToSend);
} catch(e) {}
 
const wss = new WebSocket.Server({ port: 6628 });
console.log('ready on 6628');
 
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(data) {
	console.log('inc msg with data ', data);
    
	if (data.length < 3) {
		ws.send('err.wrongNick');
		console.log('err. wrongNick becouse length', data.length);
		return
	}
	
	arData = data.split('/');
	let cmd = arData[0]; // check add update
	let nick = arData[1];
	console.log('got cmd', cmd, 'nik', nick);
	
	if (cmd == 'check') {
		
		if (oNick[nick]) {			
			ws.send('err. nick '+nick+' is used');
			console.log('err. nick '+nick+' is used');
		} else {
			ws.send('ok');
			console.log('ok. available.');
		}
		
	} else if (cmd == 'add') {
		
		oNick[nick] = 1;
		fs.writeFile(nicksFileName, JSON.stringify(oNick), ()=>{});
		ws.send('ok. added.');
		console.log('ok. added.');
		
	} else if (cmd == 'update') {
		
		let sourceNick = arData[2]
		oNick[nick] = 1;
		delete oNick[sourceNick];
		fs.writeFile(nicksFileName, JSON.stringify(oNick), ()=>{});
		ws.send('ok. updated.');
		console.log('ok. updated.');
		
	} else if (cmd == 'send') {
		
		let fromNick = arData[2]
		let tailName = arData[3]
		let text = arData[4]
		console.log('send to', nick, 'from', fromNick, 'tale', tailName, 'text', text);
		arTalesToSend.push({
			to: nick,
			fromNick,
			tailName,
			text
		});
		fs.writeFile(arTalesFileName, JSON.stringify(arTalesToSend), ()=>{});
		ws.send('ok');
		console.log('ok. sent.', arTalesToSend);
		
	} else if (cmd == 'receive') {
		
		console.log('want to receive', nick);
		arRes = [];
		arTalesToSend.forEach(el=>{
			if (nick == 'all') {
				arRes.push(el);
			} else {
				if (el.to == nick) {
					arRes.push(el);
				}
			}
		});
		ws.send(JSON.stringify(arRes));
		console.log('ok. sent ', arRes.length);

	} else if (cmd == 'del') {
		
		console.log('want to del', nick);
		let taleToDel = JSON.parse(nick);
		console.log(taleToDel);
		
		arTalesToSend = arTalesToSend.filter(el => {
			if (el.to != taleToDel.to) return true;
			if (el.fromNick != taleToDel.fromNick) return true;
			if (el.taleName != taleToDel.taleName) return true;
			return false;
		});
		
		console.log('arTalesToSend after filter ', arTalesToSend.length);
		//console.log(arTalesToSend);
		fs.writeFile(arTalesFileName, JSON.stringify(arTalesToSend), ()=>{});
		
		ws.send('ok');
		console.log('ok. sent ', arRes.length);
		
	}
	
  });
});
