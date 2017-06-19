{ Rnd } = require "../randomGenerators.coffee"
rnd = new Rnd()

{ Check } = require "../checks.coffee"

# nerdamer = require "/imports/modules/nerdamer/nerdamer.core.js"
# require "/imports/modules/nerdamer/Solve.js"

math = require "mathjs"

exports.unitsGenerator = generator =
  transformUnit : (unitNamesGenerator) ->
    (level = 1) ->
      math.config
        number : "BigNumber"
        precision : 8
      [enu, deno] = switch level
        when 1 then [99, 1]
        else
          [999, 10]
      [problemUnit, solutionUnit] = unitNamesGenerator()
      problemNumber = math.eval("(#{rnd.intPlus enu}/#{deno})")
      problem = "#{problemNumber} #{problemUnit}"
      solution = math.unit(problem).to(solutionUnit).toString()
      #returns
      problem : "not Used"
      problemTeX : "\\text{Wandle }#{problem}\\text{ um in }#{solutionUnit}"
      description : "Rechne die Einheiten um:"
      solution : solution
      answerPreprocessor : (answer) -> answer
      checks : [Check.exactValueWithUnit, Check.unitIs(solutionUnit)]
  addUnit : (unitNamesGenerator) ->
    (level = 1) ->
      math.config
        number : "BigNumber"
        precision : 64
      [enu, deno] = switch level
        when 1 then [99, 1]
        else
          [999, 10]
      unitNames = unitNamesGenerator()
      [a,b] =
        rnd.intsPlus(enu)[0..1].map (n, i) ->
          math.eval("(#{n}/#{deno}) #{unitNames[i]}")
      solution = math.eval("a+b",{a,b}).toString()
      #returns
      problem : "not Used"
      problemTeX : "#{a} + #{b}"
      description : "Berechne die Summe. Wähle eine passende Einheit."
      solution : solution
      answerPreprocessor : (answer) -> answer
      checks : [Check.exactValueWithUnit]
  multiplyUnit : (unitNamesGenerator) ->
    (level = 1) ->
      math.config
        number : "BigNumber"
        precision : 64
      [enu, deno] = switch level
        when 1 then [99, 1]
        else
          [999, 10]
      unitNames = unitNamesGenerator()
      [a,b] =
        rnd.intsPlus(enu)[0..1].map (n, i) ->
          math.eval("(#{n}/#{deno}) #{unitNames[i]}")
      solution = math.eval("a*b",{a,b}).toString()
      #returns
      problem : "not Used"
      problemTeX : "#{a} \\times #{b}"
      description : "Berechne das Produkt. Wähle eine passende Einheit."
      solution : solution
      answerPreprocessor : (answer) -> answer
      checks : [Check.exactValueWithUnit]

exports.units =
  length :
    title : "Länge"
    description : "Umrechnen von Flächeineinheiten. Summe von Längen."
    problems : [
      levels : [1..2]
      generator : generator.transformUnit rnd.uniqueLengthUnits
    ,
      levels : [2..3]
      levelOffset : -1
      generator : generator.addUnit rnd.uniqueLengthUnits
    ]
  area :
    title : "Fläche"
    description : "Umrechnen von Flächeneinheiten. Produkte von Längen."
    problems : [
      levels : [1..2]
      generator : generator.transformUnit rnd.uniqueAreaUnits
    ,
      levels : [2..3]
      levelOffset : -1
      generator : generator.multiplyUnit rnd.uniqueLengthUnits
    ]
  volume :
    title : "Volumen"
    description : "Umrechnen von Volumeneinheiten."
    problems : [
      levels : [1..2]
      generator : generator.transformUnit rnd.uniqueVolumeUnits
    ]
  mix :
    title : "Länge, Fläche und Volumen"
    description : "Vermischete Aufgben"
    problems : [
      levels : [1..2]
      generator : generator.transformUnit rnd.uniqueLengthUnits
    ,
      levels : [2..3]
      levelOffset : -1
      generator : generator.addUnit rnd.uniqueLengthUnits
    ,
      levels : [1..2]
      generator : generator.transformUnit rnd.uniqueAreaUnits
    ,
      levels : [1..2]
      generator : generator.multiplyUnit rnd.uniqueLengthUnits
    ,
      levels : [1..2]
      generator : generator.transformUnit rnd.uniqueVolumeUnits
    ]