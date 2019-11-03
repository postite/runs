using RunTools;
using Runs;
import utest.Runner;
import utest.Assert;
import utest.ui.Report;
class TST{

	public function new(){
		var pace:Pace="5:40";
		var km:Kmh=pace;
		trace(pace.seconds);
		trace(km);
		var km:Kmh= 10;
		trace( (km:Pace));

		var vma:VMA=13.5;
		vma.percent(70).log("VMA");
		var fmgirl=FCM.fromAgeGirl(33);
		fmgirl.log("");
		var fcm:FCM=177;
		fcm.percent(70).log("FCM");

		var karvo:KFCM={ageBoy:43,bpm:64};
		karvo.percent(70).log("KFCM");

		var karvo:KFCM={fcm:177,bpm:64};
		karvo.percent(70).log("KFCM");


		for (a  in 8 ... 20){
			var km:Kmh=a*1.1;
			trace('$km km/H ='+(km:Pace));
		}


		utest.UTest.run([
			new TestPace(),
			new TestKmh(),
			new TestVmA(),
			new TestFCM(),
			new TestKFCM()
			]);


		

	}
	public static function main()
		new TST();
}

class TestPace extends utest.Test {

	var pace:Pace;
	public function setup(){
		pace ="6:00";
	}
	public function testPace(){
		Assert.equals(0,pace.seconds);
		Assert.equals(6,pace.minutes);
	}
	public function testToKMH(){
		var km:Kmh=pace;
		Assert.equals(10,km);
	}
	
	public function testtoString(){
		Assert.equals("06:00",accepsString(pace));
	}

	function accepsString(d:String):String{
		return d;
	}
}
class TestKmh extends utest.Test {

	var km:Kmh;
	public function setup(){
		km=10;
	}
	public function testKm(){
		Assert.equals(10,km);
		
	}
	public function testToPace(){
		var pace:Pace=km;
		Assert.equals(6,pace.minutes);
		Assert.equals(0,pace.seconds);
	}
	public function testsurDistance(){
		var dist=km.surDistance(10);
		Assert.equals("1:00:00",dist.toString());
	}
	public function testPendant(){
		var pdt= km.pendant("1:00:00");
		Assert.equals(10,pdt);
	}
	public function testfromdistanceTps(){
		var vitesse=Kmh.fromdistanceTps(10,"1:00:00");
		Assert.equals(10,vitesse);
	}
	public function testSplits(){
		var tab=[];
		var dist=10;
		var temps:RunTime="1:00:00";
		var kmh=Kmh.fromdistanceTps(dist,temps);
		for ( a in 1...dist+1){
			var split=kmh.surDistance(a);
			tab.push(split);
		}
		Assert.equals("0:06:00",tab[0].toString());
		Assert.equals("0:12:00",tab[1].toString());
		Assert.equals("0:30:00",tab[4].toString());
		Assert.equals("1:00:00",tab[9].toString());
	}

	function testfromMS(){
		var metersbyseconds=3;
		Assert.equals(10.8,Kmh.fromMS(metersbyseconds));
	}
	function testtoMS(){
		var km=10.8;
		Assert.equals(3,Kmh.toMS(km));
	}

	function testToString(){
		//Assert.equals("10 Km/h", km.toStr());
		Assert.equals("10 Km/h", km.toString());
	}
	
}

class TestVmA extends utest.Test{
	var vma:VMA;
	public function setup(){
		vma=20;
	}
	public function testPercent()
	Assert.equals(10,vma.percent(50));

	public function testtoPercent(){
		Assert.equals(50,vma.toPercent((10:Kmh)));
	}

	public function testPacetoPercent(){
		var pace:Pace="6:00";
		Assert.equals(50,vma.toPercent(pace));
		
	}
}

class TestFCM extends utest.Test{
	var fcm:FCM;
	public function setup(){
		fcm=177;
	}
	public function testPercent(){
		Assert.equals(177/2,fcm.percent(50));
		Assert.equals(123.9,fcm.percent(70));
	}
	public function testBoy(){
		var FCMBoy=FCM.fromAgeBoy(43);
		Assert.equals(177,FCMBoy);
	}
	public function testGirl(){
		var FCMGirl=FCM.fromAgeGirl(46);
		Assert.equals(180,FCMGirl);
	}
}

class TestKFCM extends utest.Test{
	var fcm:KFCM;
	public function setup(){
		fcm={ageBoy:43,bpm:64};
	}
	public function testPercent(){
		
		Assert.equals(143.1,fcm.percent(70));
	}
	public function testGirl(){
		fcm={ageGirl:40,bpm:64};
		Assert.equals(149.4,fcm.percent(70));
	}
	
}

