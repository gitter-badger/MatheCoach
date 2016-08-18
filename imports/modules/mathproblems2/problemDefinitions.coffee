{ Rnd } = require "./randomGenerators.coffee"
rnd = new Rnd()

{ re } = require "./RegExs.coffee"

nerdamer = require "/imports/modules/nerdamer/nerdamer.core.js"
require "/imports/modules/nerdamer/Solve.js"

{ fractionGenerator } = require "./problemGenerators/fractions.coffee"

#math = require "mathjs"


exports.modules = [
  "bruch1"
  "bruch2"
  "bruch3"
  "test"
  "examples"
]

exports.problemDefinitions =
  bruch1 :
    title : "Bruchrechnen 1"
    description : "Addition und Subtraktion von Brüchen"
    problems : [
      levels : [1..2]
      generator : fractionGenerator.strichGleichnamig
    ,
      levels : [2..4]
      levelOffset : -1
      generator : fractionGenerator.strichUngleichnamig
    ]
  bruch2 :
    title : "Bruchrechnen 2"
    description : "Multiplikation von Brüchen"
    problems : [
      levels : [1..2]
      generator : fractionGenerator.malGanzeZahl
    ,
      levels : [1..3]
      generator : fractionGenerator.malBruchKuerzbar
    ,
      levels : [2..3]
      generator : fractionGenerator.malKreuzKuerzbar
    ]
  bruch3 :
    title : "Bruchrechnen 3"
    description : "Vermischte Aufgaben zur Bruchrechnung"
    problems : [
      levels : [1..2]
      levelOffset : 1
      generator : fractionGenerator.strichGleichnamig
    ,
      levels : [1..4]
      generator : fractionGenerator.strichUngleichnamig
    ,
      levels : [1]
      levelOffset : 1
      generator : fractionGenerator.malGanzeZahl
    ,
      levels : [1..4]
      generator : fractionGenerator.malBruch
    ,
      levels : [2..4]
      levelOffset : -1
      generator : fractionGenerator.zusammenGesetzt
    ]
  test :
    title : "Test"
    description : "Neue Aufgabengeneratoren, die noch getestet werden müssen"
    problems : [
      levels : [1]
      generator : (level = 1) ->
        [a, b, c] = rnd.intsPlus(9)
        x = rnd.letter()
        leftSide = "(#{x} + #{a})*(#{x} + #{b})"
        rightSide = "(#{x} + #{c})^2"
        problem = "#{leftSide} = #{rightSide}"
        leftPoly = nerdamer("expand(#{leftSide})").text()
        rightPoly = nerdamer("expand(#{rightSide})").text()
        equation = "#{leftPoly} = #{rightPoly}"
        solution = nerdamer.solveEquations(equation, x).toString()
        #return
        problem : problem
        solution : solution
        description : "Löse die Gleichung nach #{x} auf:"
    ]
  examples :
    title : "Vermischte Übungsaufgaben"
    description : "Eine bunte Mischung von Aufgaben \
      aus den unterschiedlichsten Themengebieten"
    problems : [
      levels : [1]
      generator :(level = 1) ->
          [a, b, c] = rnd.ints2Plus()
          x = rnd.letter()
          problem = "#{a}#{x} + #{b} = #{c}"
          solution = nerdamer.solveEquations(problem, x).toString()
          #return
          problem : problem
          solution : solution
          description : "Löse die Gleichung nach #{x} auf."
          hint : "(Du kannst die Antwort als Gleichung mit #{x} auf \
          auf der linken Seite schreiben, oder einfach den Wert von \
          #{x} eingeben)"
    ,
      levels : [1]
      generator : (level = 1) ->
        [a, b, c, d] = rnd.ints2Plus(9)
        x = rnd.letter()
        op = rnd.opStrich()
        opStr = if op is "+" then "Addiere" else "Subtrahiere"
        #return
        problem : "#{a}#{x}/#{c} #{op} #{b}#{x}/#{d}"
        description : "#{opStr} die Brüche:"
    ,
      levels : [1]
      generator : (level = 1) ->
        [a, b, c] = rnd.ints2Plus()
        #return:
        problem : "#{a}/#{c} + #{b}/#{c}"
        #solution : "#{a+b}/#{c}"
        form : /\d+\/\d+/
        description : "Addiere die Brüche:"
        hint : "Die Brüche sind schon gleichnamig."
    ,
      levels : [1]
      generator : (level = 1) ->
        [a, b] = rnd.intsPlus()
        [c, d] = rnd.uniqueInts2Plus(9)
        #return:
        problem : "#{a}/#{c} + #{b}/#{d}"
        #solution : "#{a*d + b*c} / #{c*d}"
        form : /\d+\/\d+/
        description : "Addiere die Brüche:"
        hint : "Mache gleichnamig ehe Du addierst"
    ,
      levels : [1]
      generator : (level = 1) ->
        [a, b, c, d] = rnd.uniqueInts2Plus(9)
        op = rnd.op()
        #return:
        problem : "(#{a}/#{c}) #{op} (#{b}/#{d})"
        description : "Löse die Bruchrechenaufgabe"
    ,
      levels : [1]
      generator : (level = 1) ->
        [a, c] = rnd.primeReducable(10)
        [b, d] = rnd.primeReducable(10)
        op = rnd.opStrich()
        opStr = if op is "+"
          "die Summe"
        else
          "die Differenz"
        #return
        problem : "#{a}/#{c} #{op} #{b}/#{d}"
        form: /\d+\/\d+/
        description : "Berechne #{opStr} der Brüche"
        hint : "Wenn Du die Brüche kürzt, ehe du #{opStr} berechnest, \
        werden die Produkte beim Gleichnamigmachen in den meisten \
        Fällen deutlich einfacher."
    ,
      levels : [1]
      generator : (level = 1) ->
        [a, b, c, d, e, f] = rnd.uniquePrimes(20)
        op = rnd.opStrich()
        #return:
        problem : "#{a}/#{b} * (#{c}/#{d} #{op} #{e}/#{f})"
        description : "Löse die fiese Bruchrechenaufgabe:"
        hint : "Diese Aufgabe ist absichtlich gemein. Sie besteht aus \
        unterschiedlichen Primzahlen, so dass man garantiert nicht \
        kürzen kann."
    ,
      levels : [1]
      generator : (level = 1) ->
        a = rnd.int2Plus()
        problem : "sqrt(#{a**2})"
        description : "Ziehe die Wurzel:"
    ,
      levels : [1]
      generator : (level = 1) ->
        a = rnd.int2Plus(9)
        [b, c] = rnd.uniquePrimes(7)
        description : "Ziehe teilweise die Wurzel:"
        problem : "sqrt(#{a*a*b*c})"
        solution : "#{a}*sqrt(#{b*c})"
        hint : "Für die Wurzel schreibst Du sqrt()"
    ]
