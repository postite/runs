import thx.Time;
using thx.Strings;
using thx.Ints;
using RunTools;

class Runs{}


typedef Allure=Map<Al,Array<Int>>;


#if coconut
@:pure
typedef Tup=tink.pure.List<Int>;
#end

enum Al{
	REC;
	EF;
	EA;
	AM;
	ASM;
	A10K;
	A5K;
	AVMA;
}

@:forward
@:enum abstract RUNdistance(Float) from Float to Float{
	var marathon=42.195;
	var semi=21.097;
	var K5=5;
	var K10=10;
	var none=1;

	public function new(t:Float){
		this = t;
	}

	@:from 
	public static function fromMeters(m:Float):RUNdistance{
		return new RUNdistance(m/1000);
	}

	@:to 
	public function toString():String{
		return Std.string(this)+"Km";
	}

}

@:observable
@:forward
@:forwardStatics
abstract RunTime (Time) from Time to Time{

}

@:observable
@:forward
@:forwardStatics
abstract Pace(Time) from Time to Time{


	public function new(t:Time){
		this = t;
	}

	@:to 
	public inline static function toKm(p:Pace):Kmh{
		return 1 / ((p.minutes * 60 + p.seconds)/3600);
	}
	
	@:to
	public inline static function toSeconds(p:Pace):Int{
		return p.minutes*60 +p.seconds;
	}
	@:to
	public inline static function toMilliseconds(p:Pace):Int{
		return p.minutes*60*1000 +p.seconds*1000+p.milliseconds;
	}

@:from public static function fromString(s : String) : Pace {
    var pattern = ~/^([-+])?(?:(\d+)[.](\d{1,2})|(\d+))[:](\d{2})(?:[:](\d{2})(?:\.(\d+))?)?$/;
    if(!pattern.match(s))
      throw new thx.Error('unable to parse Time string: "$s"');
    var smticks = pattern.matched(7),
        mticks = 0;
    if(null != smticks) {
      smticks = "1" + smticks.rpad("0", 7).substring(0, 7);
      mticks = Std.parseInt(smticks) - 10000000;
    }

    

    var days = 0,
        hours = 0,
        minutes = Std.parseInt(pattern.matched(4)),
        seconds = Std.parseInt(pattern.matched(5));
    if(null != pattern.matched(2)) {
      days = Std.parseInt(pattern.matched(2));
      hours = Std.parseInt(pattern.matched(3));
    } else {
      //hours = Std.parseInt(pattern.matched(4));

    }

    var time = Time.create(
            days * 24 + hours,
            minutes,
            seconds
          ) + mticks;

    if(pattern.matched(1) == "-") {
      return time.negate();
    } else {
      return time;
    }
}

 @:to public function toString() {
   var timeAbs = this.abs(),
        ticksInSecondAbs = timeAbs.ticksInSecond,
        decimals = ticksInSecondAbs != 0 ? ('.' + ticksInSecondAbs.lpad("0", 7).trimCharsRight("0")) : "";

    return (this.isNegative ? "-" : "") +
      '${timeAbs.minutes.lpad("0", 2)}:${timeAbs.seconds.lpad("0", 2)}' +
decimals;
	}

}

@:forward
abstract Kmh(Float) from Float to Float{

	public function new(f:Float):Kmh{
		return this=f;
	}
		@:to 
		public function toPace():Pace{
			return Time.fromSeconds( Math.floor(3600/(this:Float)));
			//return Pace.fromSeconds( Math.floor(3600/p) );
		}
		// @:to
		// public static function toStr(p:Kmh):String{
		// 	return Std.string(p) +" Km/h";
		// }
		@:to
		public  function toString():String{
			return  '$this Km/h';
		}
		public function surDistance(distance:Float):Time{	
   //temps=Distance/Vitesse 
   

    var time= Time.fromSeconds( Math.floor((distance/this)*3600));
  
  return time;
	}
		public function pendant(time:Time):Float{
			//D=V×t	
			return ((this) * thx.Int64s.toFloat(time.totalSeconds))/3600;
		}
		
	
		public static function fromdistanceTps(dist:Float,temps:Time):Kmh{
				//V=D/t
			return (dist*3600/thx.Int64s.toFloat(temps.totalSeconds));
		}
		
		//from meters par seconds
		public static function fromMS(ms:Float):Kmh{
			return new Kmh((ms*18)/5);
		}

		public static function toMS(me:Kmh):Float{
			return new Kmh(((me:Float)*5)/18);
		}
		
		


}

@:forward
abstract VMA(Kmh) from Kmh to Kmh{

	public function new(t:Kmh){
		this=t;
	}
	public function toPercent(p:Kmh):Float{
		return ((p:Float)*100)/(this:Float);
	}
	public function percent(p:Float):Kmh{
		//return (p*100)/(this:Float);
		return p.reg23(this);
	}
	public function fromPercent(p:Float):Float{
		return p.reverseReg23(this);
	}
	public function toVO2Max():Float{
		return (this:Float) * 3.5;
	}

	@:to
		public static function toStr(p:Kmh):String{
			return Std.string(p);
		}
}


abstract FCM(Float) from Float to Float{

	public function new(t:Float){
		this=t;
	}
	public function fromPercent(p:Float):Float{
		return p.reverseReg23(this);
	}
	public function percent(p:Float):Float{
		return p.reg23(this);
	}
	public static function fromAgeBoy(age:Float):FCM{
		return 220-age;
	}
	public static function fromAgeGirl(age:Float):FCM{
		return 226-age;
	}
	@:to
		public static function toStr(p:Kmh):String{
			return Std.string(p);
		}

}

typedef KarvoBoy={
	ageBoy:Int,
	bpm:Int
}
typedef KarvoGirl={
	ageGirl:Int,
	bpm:Int
}
typedef Karvo={
	fcm:Int,
	bpm:Int
}
//methode Karvonen
@:forward
abstract KFCM(Karvo) from Karvo to Karvo{

	
	public function new(t:Karvo){
		trace(t);
		this=t;
	}
	public function percent(per:Float):Float{
		
		return per.reg23(this.fcm-this.bpm)+this.bpm;
		
	}
	public function fromPercent(per:Float):Float{
		return per.reverseReg23(this.fcm-this.bpm)+this.bpm; //?
	}
	@:from
	public static  function fromAgeBoy(k:KarvoBoy):KFCM{
		return new KFCM({fcm:220-k.ageBoy,bpm:k.bpm});
	}
	@:from
	public static  function fromAgeGirl(k:KarvoGirl):KFCM{
		return new KFCM({fcm:226-k.ageGirl,bpm:k.bpm});
	}


	

}




