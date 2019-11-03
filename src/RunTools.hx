using Runs;
import thx.Time;
class RunTools {
	static public function reg23(per:Float, max:Float):Float {
		return (per * max) / 100;
	}

	static public function reverseReg23(per:Float, max:Float):Float {
		return (per * 100) / max;
	}

	static public function Alitteral(al:Al):String {
		return "allure " + switch (al) {
			case REC: "récuperation";
			case EF: "endurance fondamentale (aerobie)";
			case EA: "footing active (seuil aerobie)";
			case AM: "marathon";
			case ASM: "semi-marathon";
			case A10K: "10k (anaerobie)";
			case A5K: "VMA~- moyenne à longue 5K";
			case AVMA: "VMA+- courte";
		}
	}

	static public function ALdistance(al:Al):RUNdistance{
		return switch (al) {
			case REC:Runs.RUNdistance.none;
			case EF:Runs.RUNdistance.none;
			case EA:Runs.RUNdistance.none;
			case AM:Runs.RUNdistance.marathon;
			case ASM:Runs.RUNdistance.semi;
			case A10K:Runs.RUNdistance.K10;
			case A5K:Runs.RUNdistance.K5;
			case AVMA:Runs.RUNdistance.none;
		}
	} 

	static public function tempsDistance(al:Al,allure:Kmh):Time{
		return allure.surDistance(ALdistance(al));
	}

	static public inline function log<E>(e:E, ?txt:String = "") {
		trace('$txt = $e');

		return e;
	}

	public static function strBetween(str:String, del:String = "-"):String {
		// var reg =new EReg("\\"+str+"(.*?)\\"+str, "g");// ~/\-(.*?)\-/g;
		var reg = new EReg('$del(.*?)$del', "g"); // ~/\-(.*?)\-/g;
		if (reg.match(str))
			return reg.matched(1);
		return str;
	}
}
