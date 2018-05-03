package tests.flashbite.helpers;

import flashbite.helpers.HelpersDate;
import haxe.unit.TestCase;

/**
 * TestCase for HelpersDate
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersDateTestCase extends TestCase
{
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	public function test_parseToDate():Void
	{
		//incorrect
		var outDate_incorrect_null = HelpersDate.parseToDate(null);
		assertTrue(outDate_incorrect_null == null);
		
		var outDate_incorrect_empty = HelpersDate.parseToDate("");
		assertTrue(outDate_incorrect_empty == null);
		
		var outDate_incorrect_wrongFormat1 = HelpersDate.parseToDate("T");
		assertTrue(outDate_incorrect_wrongFormat1 == null);
		
		var outDate_incorrect_wrongFormat2 = HelpersDate.parseToDate("19991231T"); //no hours
		assertTrue(outDate_incorrect_wrongFormat2 == null);
		
		var outDate_incorrect_wrongFormat3 = HelpersDate.parseToDate("19991231T121212"); //no ms
		assertTrue(outDate_incorrect_wrongFormat3 == null);
		
		var outDate_incorrect_wrongFormat4 = HelpersDate.parseToDate("19991231A1212120000"); //no T
		assertTrue(outDate_incorrect_wrongFormat4 == null);
		
		//correct - Date.parseString :"YYYY-MM-DD hh:mm:ss", "YYYY-MM-DD", "hh:mm:ss"
		var outDate_correct_parse1 = HelpersDate.parseToDate("2012-01-01 12:12:12");
		assertTrue(outDate_correct_parse1 != null);
		assertEquals(2012, outDate_correct_parse1.getFullYear());
		assertEquals(0, outDate_correct_parse1.getMonth());
		assertEquals(1, outDate_correct_parse1.getDate());
		assertEquals(12, outDate_correct_parse1.getHours());
		assertEquals(12, outDate_correct_parse1.getMinutes());
		assertEquals(12, outDate_correct_parse1.getSeconds());
		
		var outDate_correct_parse2 = HelpersDate.parseToDate("2012-01-01");
		assertTrue(outDate_correct_parse2 != null);
		
		var outDate_correct_parse3 = HelpersDate.parseToDate("12:12:12");
		assertTrue(outDate_correct_parse3 != null);
		
		//correct - format "yyyy-mm-ddThh:mm:ss:fffZ"
		var date = new Date(2018, 2, 15, 16, 29, 44); //2 is ~3 = March
		var outDateMatch = HelpersDate.parseToDate("2018-03-15T16:29:44.806Z");
		assertEquals(date.getFullYear(), outDateMatch.getFullYear());
		assertEquals(date.getMonth(), outDateMatch.getMonth());
		assertEquals(date.getDate(), outDateMatch.getDate());
		assertEquals(date.getHours(), outDateMatch.getHours());
		assertEquals(date.getMinutes(), outDateMatch.getMinutes());
		assertEquals(date.getSeconds(), outDateMatch.getSeconds());
		
		//correct - format "yyyy-mm-ddThh:mm:ss"
		var date = new Date(2018, 2, 15, 16, 29, 44); //2 is ~3 = March
		var outDateMatch = HelpersDate.parseToDate("2018-03-15T16:29:44");
		assertEquals(date.getFullYear(), outDateMatch.getFullYear());
		assertEquals(date.getMonth(), outDateMatch.getMonth());
		assertEquals(date.getDate(), outDateMatch.getDate());
		assertEquals(date.getHours(), outDateMatch.getHours());
		assertEquals(date.getMinutes(), outDateMatch.getMinutes());
		assertEquals(date.getSeconds(), outDateMatch.getSeconds());
	}
	
	public function test_getDifferenceInSecondsBetween():Void
	{
		var dateFirst = new Date(2018, 2, 15, 16, 29, 44);
		var dateSecond = new Date(2018, 2, 15, 16, 29, 45);
		
		var diffInSecs = HelpersDate.getDifferenceInSecondsBetween(dateFirst, dateSecond, false);
		assertEquals(0, diffInSecs); //no sub zero
		
		diffInSecs = HelpersDate.getDifferenceInSecondsBetween(dateFirst, dateSecond, true);
		assertTrue(diffInSecs < 0); //must be sub-zero
		
		diffInSecs = HelpersDate.getDifferenceInSecondsBetween(dateSecond, dateFirst, true);
		assertTrue(diffInSecs > 0); //must be over zero
	}
}