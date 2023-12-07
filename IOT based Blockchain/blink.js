import RpiLeds from 'rpi-leds';
import Web3 from 'web3';
import gpio from 'gpio';
export default(app)=>{
    console.log("Hi blinkExample")
    const leds = new RpiLeds();
    const web3 = new Web3();
    web3.setProvider(new web3.providers.HttpProvider("IP ADDRESS OF PI "));
    var coinbase = web3.eth.coinbase;
    var balance = web3.eth.getBalance(coinbase);
    var contactAddress = "";//Address of the contract
    var ABI = JSON.parse('[{"constant":true,"inputs":[],"name":"getData","outputs":[{"name":"retData","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"inData","type":"uint256"}],"name":"setData","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"msgData","type":"uint256"}],"name":"blinkEvent","type":"event"}]');
    const blinkContract = web3.eth.contract(ABI).at(contactAddress);
    blinkContract.blinkEvent({},(error,msg)=>{
        if(!error){
            console.log(msg);
            app.blinkLeds();
        }else{
            console.log(error);
        }
    });
    app.blinkLeds = () =>{
        app.ledStatus =false;
        let iv = setInterval(()=>{
            if(app.ledStatus){
                console.log("Sleepy.. so sleepy")
                leds.power.turnOff();
                leds.status.turnOff();
            }else{
                console.log("turn on!")
                leds.power.turnOn();
                leds.status.turnOn();
            }
            app.ledStatus = !app.ledStatus;
        },500);
        setTimeout(()=>{
            clearInterval(iv);
        },10000)
    }
return app;
}