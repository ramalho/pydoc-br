.. _tut-fp-issues:

*****************************************************
Aritmética de ponto flutuante: problemas e limitações
*****************************************************

.. sectionauthor:: Tim Peters <tim_one@users.sourceforge.net>


Números de ponto flutuante são representados no hardware do computador como frações binárias (base 2). Por exemplo, a fração decimal::

   0.125

tem o valor 1/10 + 2/100 + 5/1000, e da mesma maneira a fração binária::

   0.001

tem o valor 0/2 + 0/4 + 1/8.  Essas duas frações têm valores idênticos, a única
diferença real é que a primeira está representada na forma de frações base 10,
e a segunda na base 2.

Infelizmente, muitas frações decimais não podem ser representadas precisamente
como frações binárias. O resultado é que, em geral, os números decimais de
ponto flutuante que você digita acabam sendo armazenados de forma apenas
aproximada, na forma de números binários de ponto flutuante.


The problem is easier to understand at first in base 10.  Consider the fraction
1/3.  You can approximate that as a base 10 fraction::

O problema é mais fácil de entender primeiro em base 10. Considere a fração
1/3. Podemos represtentá-la aproximadamente como uma fração base 10::


   0.3

ou melhor, ::

   0.33

ou melhor, ::

   0.333

e assim por diante. Não importa quantos dígitos você está disposto a escrever,
o resultado nunca será exatamente 1/3, mas será uma aproximação de cada vez
melhor 1/3.

In the same way, no matter how many base 2 digits you're willing to use, the
decimal value 0.1 cannot be represented exactly as a base 2 fraction.  In base
2, 1/10 is the infinitely repeating fraction ::

Da mesma forma, não importa quantos dígitos de base 2 você está disposto a
usar, o valor decimal 0.1 não pode ser representado exatamente como uma fração
de base 2. Em base 2, 1/10 é uma fração binária que se repete infinitamente ::

   0.0001100110011001100110011001100110011001100110011...

Se limitamos a representação a qualquer número finito de bits, obtemos apenas
uma aproximação.

Em uma máquina típica rodando Python, há 53 bits de precisão disponível para
um ``float``, de modo que o valor armazenado internamente quando você digita
o número decimal ``0.1`` é esta fração binária ::


   0.00011001100110011001100110011001100110011001100110011010

que chega perto, mas não é exatamente igual a 1/10.

It's easy to forget that the stored value is an approximation to the original
decimal fraction, because of the way that floats are displayed at the
interpreter prompt.  Python only prints a decimal approximation to the true
decimal value of the binary approximation stored by the machine.  If Python
were to print the true decimal value of the binary approximation stored for
0.1, it would have to display ::

É fácil esquecer que o valor armazenado é uma aproximação da fração decimal
original, devido à forma como floats são exibidos no interpretador interativo.
Python exibe apenas uma aproximação decimal do verdadeiro valor decimal da
aproximação binária armazenada pela máquina. Se Python exibisse o verdadeiro
valor decimal da aproximação binária que representa o decimal 0.1, teria
que mostrar::

   >>> 0.1
   0.1000000000000000055511151231257827021181583404541015625

Isso é bem mais dígitos do que a maioria das pessoas considera útil, então Python
limita o número de dígitos, apresentando em vez disso um valor arredondado::

   >>> 0.1
   0.1

É importante perceber que isso é, de fato, uma ilusão: o valor na máquina não
é exatamente 1/10, estamos simplesmente arredondando a exibição do verdadeiro
valor na máquina. Esse fato torna-se evidente logo que você tenta fazer
aritmética com estes valores::

   >>> 0.1 + 0.2
   0.30000000000000004

Note que esse é a própria natureza do ponto flutuante binário: não é um bug em
Python, e nem é um bug em seu código. Você verá o mesmo tipo de coisa em todas
as linguagens que usam as instruções de aritmética de ponto flutuante do
hardware (apesar de algumas linguagens não *mostrarem* a diferença, por
padrão, ou em todos os modos de saída).

Outras surpresas decorrem desse fato. Por exemplo, se tentar arredondar o
valor 2.675 para duas casas decimais, obterá esse resultado::

   >>> round(2.675, 2)
   2.67

The documentation for the built-in :func:`round` function says that it rounds
to the nearest value, rounding ties away from zero.  Since the decimal fraction
2.675 is exactly halfway between 2.67 and 2.68, you might expect the result
here to be (a binary approximation to) 2.68.  It's not, because when the
decimal string ``2.675`` is converted to a binary floating-point number, it's
again replaced with a binary approximation, whose exact value is ::

A documentação da função embutida :func:`round` diz que ela arredonda para o
valor mais próximo, e em caso de empate opta pela aproximação mais distante de
zero. Uma vez que a fração decimal 2.675 fica exatamente a meio caminho entre
2.67 e 2.68, poderia-se esperar que o resultado fosse (uma aproximação binária
de) 2.68. Mas não é, porque quando a string decimal ``2.675`` é convertida em
um número de ponto flutuante binário, é substituída por uma aproximação
binária, cujo valor exato é::

   2.67499999999999982236431605997495353221893310546875

Uma vez que esta aproximação é ligeiramente mais próxima de 2.67 do que de
2.68, acaba sendo arredondada para baixo.

If you're in a situation where you care which way your decimal halfway-cases
are rounded, you should consider using the :mod:`decimal` module.
Incidentally, the :mod:`decimal` module also provides a nice way to "see" the
exact value that's stored in any particular Python float ::

Se você estiver em uma situação onde você se importa o caminho que o seu
decimal meias-casos são arredondados, você deve considerar usar o: mod:
`módulo` decimal. Aliás, a: mod: `decimal` módulo também fornece uma boa
maneira de "ver" o valor exato que é armazenado em qualquer bóia Python
especial ::


   >>> from decimal import Decimal
   >>> Decimal(2.675)
   Decimal('2.67499999999999982236431605997495353221893310546875')

Another consequence is that since 0.1 is not exactly 1/10, summing ten values
of 0.1 may not yield exactly 1.0, either::

   >>> sum = 0.0
   >>> for i in range(10):
   ...     sum += 0.1
   ...
   >>> sum
   0.9999999999999999

Binary floating-point arithmetic holds many surprises like this.  The problem
with "0.1" is explained in precise detail below, in the "Representation Error"
section.  See `The Perils of Floating Point <http://www.lahey.com/float.htm>`_
for a more complete account of other common surprises.

As that says near the end, "there are no easy answers."  Still, don't be unduly
wary of floating-point!  The errors in Python float operations are inherited
from the floating-point hardware, and on most machines are on the order of no
more than 1 part in 2\*\*53 per operation.  That's more than adequate for most
tasks, but you do need to keep in mind that it's not decimal arithmetic, and
that every float operation can suffer a new rounding error.

While pathological cases do exist, for most casual use of floating-point
arithmetic you'll see the result you expect in the end if you simply round the
display of your final results to the number of decimal digits you expect.  For
fine control over how a float is displayed see the :meth:`str.format` method's
format specifiers in :ref:`formatstrings`.


.. _tut-fp-error:

Representation Error
====================

This section explains the "0.1" example in detail, and shows how you can
perform an exact analysis of cases like this yourself.  Basic familiarity with
binary floating-point representation is assumed.

:dfn:`Representation error` refers to the fact that some (most, actually)
decimal fractions cannot be represented exactly as binary (base 2) fractions.
This is the chief reason why Python (or Perl, C, C++, Java, Fortran, and many
others) often won't display the exact decimal number you expect::

   >>> 0.1 + 0.2
   0.30000000000000004

Why is that?  1/10 and 2/10 are not exactly representable as a binary
fraction. Almost all machines today (July 2010) use IEEE-754 floating point
arithmetic, and almost all platforms map Python floats to IEEE-754 "double
precision".  754 doubles contain 53 bits of precision, so on input the computer
strives to convert 0.1 to the closest fraction it can of the form *J*/2**\ *N*
where *J* is an integer containing exactly 53 bits.  Rewriting ::

   1 / 10 ~= J / (2**N)

as ::

   J ~= 2**N / 10

and recalling that *J* has exactly 53 bits (is ``>= 2**52`` but ``< 2**53``),
the best value for *N* is 56::

   >>> 2**52
   4503599627370496
   >>> 2**53
   9007199254740992
   >>> 2**56/10
   7205759403792793

That is, 56 is the only value for *N* that leaves *J* with exactly 53 bits.
The best possible value for *J* is then that quotient rounded::

   >>> q, r = divmod(2**56, 10)
   >>> r
   6

Since the remainder is more than half of 10, the best approximation is obtained
by rounding up::

   >>> q+1
   7205759403792794

Therefore the best possible approximation to 1/10 in 754 double precision is
that over 2\*\*56, or ::

   7205759403792794 / 72057594037927936

Note that since we rounded up, this is actually a little bit larger than 1/10;
if we had not rounded up, the quotient would have been a little bit smaller
than 1/10.  But in no case can it be *exactly* 1/10!

So the computer never "sees" 1/10:  what it sees is the exact fraction given
above, the best 754 double approximation it can get::

   >>> .1 * 2**56
   7205759403792794.0

If we multiply that fraction by 10\*\*30, we can see the (truncated) value of
its 30 most significant decimal digits::

   >>> 7205759403792794 * 10**30 // 2**56
   100000000000000005551115123125L

meaning that the exact number stored in the computer is approximately equal to
the decimal value 0.100000000000000005551115123125.  In versions prior to
Python 2.7 and Python 3.1, Python rounded this value to 17 significant digits,
giving '0.10000000000000001'.  In current versions, Python displays a value
based on the shortest decimal fraction that rounds correctly back to the true
binary value, resulting simply in '0.1'.
