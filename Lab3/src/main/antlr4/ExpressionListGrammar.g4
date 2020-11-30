grammar ExpressionListGrammar;

parse returns [String answer]
    :   expressionListValue=expressionList { $answer = $expressionListValue.list.toString(); }
    ;

expressionList returns [ExpressionResultList list]
    :   firstExpression=expression[new ExpressionResultList()] {
            $list = new ExpressionResultList();
            $list.insert($firstExpression.expressionResult);
        }
        (
            lineSeparator
            secondExpression=expression[$list] { $list.insert($secondExpression.expressionResult); }
        )*
        EOF
    ;

expression [ExpressionResultList list] returns [ExpressionResult expressionResult]
    :   maybeWhitespaces variableName=Variable maybeWhitespaces '='
        maybeWhitespaces calculatedExpressionValue=calculatedExpression[$list]  maybeWhitespaces ';' maybeWhitespaces {
            $expressionResult = new ExpressionResult($variableName.text, $calculatedExpressionValue.value);
        }
    ;

calculatedExpression [ExpressionResultList list] returns [int value]
    :   maybeWhitespaces calculatedExpressionValue=plusAndMinus[$list] maybeWhitespaces { $value = $calculatedExpressionValue.value; }
    ;

plusAndMinus [ExpressionResultList list] returns [int value]
    :   firstExpression=multiplyAndDivide[$list] { $value = $firstExpression.value; }
        (
            maybeWhitespaces '+' maybeWhitespaces secondExpression=multiplyAndDivide[$list] { $value += $secondExpression.value; }
            |
            maybeWhitespaces '-' maybeWhitespaces secondExpression=multiplyAndDivide[$list] { $value -= $secondExpression.value; }
        )*
    ;

multiplyAndDivide [ExpressionResultList list] returns [int value]
    :   firstExpression=bracketsOrNumberOrVariable[$list] { $value = $firstExpression.value; }
        (
            maybeWhitespaces '*' maybeWhitespaces secondExpression=bracketsOrNumberOrVariable[$list] { $value *= $secondExpression.value; }
            |
            maybeWhitespaces '/' maybeWhitespaces secondExpression=bracketsOrNumberOrVariable[$list] { $value /= $secondExpression.value; }
        )*
    ;

bracketsOrNumberOrVariable [ExpressionResultList list] returns [int value]
    :   '(' innerExpression=calculatedExpression[$list] ')' { $value = $innerExpression.value; }
    |   number=Number { $value = Integer.parseInt($number.text); }
    |   variable=Variable { $value = $list.getValue($variable.text); }
    ;

maybeWhitespaces
    : Whitespace*
    ;

lineSeparator
    : ('\r')? '\n'
    ;

Number
    :   ('-')? ('0'..'9')+
    ;

Whitespace
    :   (' ' | '\t' | '\r' | '\n')
    ;

Variable
    :   ('a'..'z' | 'A'..'Z')+
    ;