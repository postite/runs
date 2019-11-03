using Main;
import thx.Time;
using RunTools;




typedef Printer= Al->Float->Float->Kmh->Kmh->String;


class Main {

	static var FCM:FCM= 180;
	static var matinBPM= 64;
	static var markdown="# FCM stats  (pour moi nov 2018)";
	
	static var VMA:VMA=13;



	
static var kalenji=[

		REC=>[65,55],
		EF=>[70,60],
		EA=>[75,65],
		AM=>[80,75],
		ASM=>[85,80],
		A10K=>[90,85],
		A5K=>[96,90]
		
	];
	
	static var runners=[

		REC=>[65,55],
		EF=>[65,62],
		EA=>[75,76],
		AM=>[80,75],
		ASM=>[85,80],
		A10K=>[90,86],
		A5K=>[96,93],
		AVMA=>[96,98]
	];
	
	static var alAdddict=[

		REC=>[60,55],
		EF=>[65,55],
		EA=>[75,70],
		AM=>[80,75],
		ASM=>[85,80],
		A10K=>[90,85],
		A5K=>[95,90],
		AVMA=>[96,98]
	];

	
	public function new() {

		
		
 		generateTableauEndurance(alAdddict,printshort).log();
 		// trace( generateTableauEndurance(alAdddict,printlong) );

 		//trace( TabPace());
 		affiche(alAdddict);




	}


	function generateTableauEndurance(map:Map<Al,Array<Int>>,printer:Printer):String{

		
		var buf=new StringBuf();
		var prevFCM:Int=null;
		var prevVMA:Int=null;
		var prevKey:Al=null;
		for (k in map.keys())
			{
 				var val=map.get(k);
 				
 				var nxtfcm=val[0];
 				var nxtvma=val[1];
 				
 				if ( prevKey!=null)
 					buf.add(printer(prevKey,
 						FCM.percent(prevFCM),
 						FCM.percent(nxtfcm),
 						VMA.percent(prevVMA),
 						VMA.percent(nxtvma)
 						));

 				prevFCM=nxtfcm;
 				prevVMA=nxtvma;
 				prevKey=k;
			}
			return buf.toString();
	}

	function TabPace():String{
		var buf=new StringBuf();
		buf.add("## corespondance km/Pace");

		  buf.add("\n|km/h|pace|\n");
		  buf.add("| ------------- | -----:|\n");
			for ( a in 7...14){

		  	for (i in a*10 ...(a*10)+10){
		  		var km:Kmh=i/10;
		  		if( i/10 ==a){

		  		buf.add('|**$km**|'+"**"+(km:Pace)+"**"+"|") ;
		  		}else{
		  		buf.add('|$km|'+(km:Pace) +"|");
		  		}
		  		buf.add("\n");
		  	}
		  }
		  return buf.toString();
	}

	function Alitteral(al:Al):String{
		return "allure " +switch ( al){
case REC:"récuperation";
case EF:"endurance fondamentale (aerobie)";
case EA:"footing active (seuil aerobie)";
case AM:"marathon";
case ASM:"semi-marathon";
case A10K:"10k (anaerobie)";
case A5K:"VMA~- moyenne à longue 5K";
case AVMA:"VMA+- courte";
		}
	}

	function printshort(al:Al,minF:Float,maxF:Float,minV:Kmh,maxV:Kmh):String{
		return '$al $minF($minV|${minV.toPace()})';

	}
	function printlong(al:Al,minF:Float,maxF:Float,minV:Kmh,maxV:Kmh):String{
		return '$al de $minF à $maxF bpm (de $minV à $maxV km/h|) de ${minV.toPace()} à ${maxV.toPace()} min/km)';

	}
	function printMark(al:Al,minF:Float,maxF:Float,minV:Kmh,maxV:Kmh):String{
		var s='- **${Alitteral(al)} ${FCM.fromPercent(minF)}>${FCM.fromPercent(maxF)} % FCM**';
		s+='(${VMA.fromPercent(minV)}>${VMA.fromPercent(maxV)}% VMA)  \n';
		s+='  - $minF bpm >  $maxF bpm  \n';
		s+='  - vma:$minV km/h (${minV.toPace()})  >  $maxV km/h(${maxV.toPace()})  \n';
		return s;

	}

	function affiche(map){
		"## fcm".mark();
 		'### pour une VMA de $VMA une FCm de $FCM et un bpm au repos de $matinBPM'.mark();
 		'--------'.mark();

 		generateTableauEndurance(map,printMark).mark();

 		
 		// "## fcmatin".mark();
 		// for (k in aerob.keys()){
 		// 	'- **$k ${aerob.get(k)[0].join("% >")}% FCM**'.mark();
 		// 	'(${aerob.get(k)[1].join("% >")}% VMA )'.mark();
 		// 	("  - "+aerob.get(k)[0][0].fcmatin(FCM,matinBPM)+"bpm" +" > "+ aerob.get(k)[0][1].fcmatin(FCM,matinBPM)+"bpm").mark(k);
 		// 	("  - vma:"+aerob.get(k)[1][0].kmOrPace(VMA)+" > "+ aerob.get(k)[1][1].kmOrPace(VMA)).mark(k);
 		// }


 		TabPace().mark();
		  //trace("\n"+ s);
		  print(markdown);
	}


	

	
	

	
	


	static public inline  function mark<E>(e:E,?txt:String=""){
		
		markdown+="\n"+e+"  ";

		return e;
	}
	


	static function print(content:String){
		sys.io.File.saveContent("./resultsFCM2.md",content);
	}

	static public function main() {
		var app = new Main();
	}
}