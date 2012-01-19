.. _tut-structures:

*******************
Estruturas de dados
*******************

Este capítulo descreve alguns pontos já abordados, porém com mais detalhes, e
adiciona outros pontos.


.. _tut-morelists:

Mais sobre listas
=================

O tipo ``list`` possui mais métodos. Aqui estão todos os métodos disponívies
em um objeto lista:

.. method:: list.append(x)
   :noindex:

   Adiciona um item ao fim da lista; equivale a ``a[len(a):] = [x]``.


.. method:: list.extend(L)
   :noindex:

   Prolonga a lista, adicionando no fim todos os elementos da lista ``L``
   passada como argumento; equivalente a ``a[len(a):] = L``.


.. method:: list.insert(i, x)
   :noindex:

   Insere um item em uma posição especificada. O primeiro argumento é o índice
   do elemento antes do qual será feita a inserção, assim ``a.insert(0, x)``
   insere no início da lista, e ``a.insert(len(a), x)`` equivale a
   ``a.append(x)``.

.. method:: list.remove(x)
   :noindex:

   Remove o primeiro item encontrado na lista cujo valor é igual a *x*. Se não existir valor igual, uma exceção ``ValueError`` é levantada.

.. method:: list.pop([i])
   :noindex:

   Remove o item na posição dada e o devolve. Se nenhum índice for
   especificado, ``a.pop()`` remove e devolve o último item na lista.
   (Os colchetes ao redor do *i* indicam que o parâmetro é opcional, não que
   você deva digitá-los daquela maneira. Você verá essa notação com frequência
   na Referência da Biblioteca Python.)

.. method:: list.index(x)
   :noindex:

   Devolve o índice do primeiro item cujo valor é igual a *x*, gerando
   ``ValueError`` se este valor não existe

.. method:: list.count(x)
   :noindex:

   Devolve o número de vezes que o valor *x* aparece na lista.

.. method:: list.sort()
   :noindex:

   Ordena os itens na própria lista *in place*.

.. method:: list.reverse()
   :noindex:

   Inverte a ordem dos elementos na lista *in place* (sem gerar uma nova
   lista).

Um exemplo que utiliza a maioria dos métodos:::

   >>> a = [66.25, 333, 333, 1, 1234.5]
   >>> print a.count(333), a.count(66.25), a.count('x')
   2 1 0
   >>> a.insert(2, -1)
   >>> a.append(333)
   >>> a
   [66.25, 333, -1, 333, 1, 1234.5, 333]
   >>> a.index(333)
   1
   >>> a.remove(333)
   >>> a
   [66.25, -1, 333, 1, 1234.5, 333]
   >>> a.reverse()
   >>> a
   [333, 1234.5, 1, 333, -1, 66.25]
   >>> a.sort()
   >>> a
   [-1, 1, 66.25, 333, 333, 1234.5]

(N.d.T. Note que os métodos que alteram a lista, inclusive ``sort`` e
``reverse``, devolvem ``None`` para lembrar o programador de que modificam a
própria lista, e não criam uma nova. O único método que altera a lista e
devolve um valor é o ``pop``)

.. _tut-lists-as-stacks:

Usando listas como pilhas
-------------------------

.. sectionauthor:: Ka-Ping Yee <ping@lfw.org>

Os métodos de lista tornam muito fácil utilizar listas como pilhas, onde o
item adicionado por último é o primeiro a ser recuperado (política “último a
entrar, primeiro a sair”). Para adicionar um item ao topo da pilha, use
:meth:`append`. Para recuperar um item do topo da pilha use :meth:`pop` sem
nenhum índice. Por exemplo::

   >>> pilha = [3, 4, 5]
   >>> pilha.append(6)
   >>> pilha.append(7)
   >>> pilha
   [3, 4, 5, 6, 7]
   >>> pilha.pop()
   7
   >>> pilha
   [3, 4, 5, 6]
   >>> pilha.pop()
   6
   >>> pilha.pop()
   5
   >>> pilha
   [3, 4]


.. _tut-lists-as-queues:

Usando listas como filas
------------------------

.. sectionauthor:: Ka-Ping Yee <ping@lfw.org>

It is also possible to use a list as a queue, where the first element added is
the first element retrieved ("first-in, first-out"); however, lists are not
efficient for this purpose.  While appends and pops from the end of list are
fast, doing inserts or pops from the beginning of a list is slow (because all
of the other elements have to be shifted by one).

Você também pode usar uma lista como uma fila, onde o primeiro item
adicionado é o primeiro a ser recuperado (política “primeiro a entrar,
primeiro a sair”); porém, listas não são eficientes para esta finalidade.
Embora *appends* e *pops* no final da lista sejam rápidos, fazer *inserts*
ou *pops* no início da lista é lento (porque todos os demais elementos tem
que ser deslocados).

Para implementar uma fila, use a classe :class:`collections.deque` que foi
projetada para permitir *appends* e *pops* eficientes nas duas extremidades.
Por exemplo::


   >>> from collections import deque
   >>> fila = deque(["Eric", "John", "Michael"])
   >>> fila.append("Terry")    # Terry chega
   >>> fila.append("Graham")   # Graham chega
   >>> fila.popleft()          # O primeiro a chegar parte
   'Eric'
   >>> fila.popleft()          # O segundo a chegar parte
   'John'
   >>> fila                    # O resto da fila, em ordem de chegada
   deque(['Michael', 'Terry', 'Graham'])

(N.d.T. neste exemplo são usados nomes de membros do grupo *Monty Python*)

.. _tut-functional:

Ferramentas de programação funcional
------------------------------------

Existem três funções embutidas que são muito úteis para processar listas:
:func:`filter`, :func:`map`, e :func:`reduce`.

``filter(funcao, sequecia)`` devolve uma nova sequência formada pelos itens do
segundo argumento para os quais ``funcao(item)`` é verdadeiro. Se a sequencia
de entrada for string ou tupla, a saída será do mesmo tipo; caso contrário, o
resultado será sempre uma lista. Por exemplo, para computar uma sequência de
números não divisíveis por 2 ou 3::

   >>> def f(x): return x % 2 != 0 and x % 3 != 0
   ...
   >>> filter(f, range(2, 25))
   [5, 7, 11, 13, 17, 19, 23]

``map(funcao, sequencia)`` aplica ``funcao(item)`` a cada item da sequência e
devolve uma lista formada pelo resultado de cada aplicação. Por exemplo, para
computar cubos::

   >>> def cubo(x): return x*x*x
   ...
   >>> map(cubo, range(1, 11))
   [1, 8, 27, 64, 125, 216, 343, 512, 729, 1000]

Mais de uma sequência pode ser passada; a função a ser aplicada deve aceitar
tantos argumentos quantas sequências forem passadas, e é invocada com o item
correspondente de cada sequência (ou ``None``, se alguma sequência for menor
que outra). Por exemplo::

   >>> seq = range(8)
   >>> def somar(x, y): return x+y
   ...
   >>> map(somar, seq, seq)
   [0, 2, 4, 6, 8, 10, 12, 14]

.. N.d.T: o parágrafo abaixo existia na versão 2.4 do tutorial, mas não
   existe na versão 2.7. Resolvi preservá-lo, complementando.

Se ``None`` for passado no lugar da função, então será aplicada a função
identidade (apenas devolve o argumento recebido). Se várias sequências forem
passadas, a lista resultante terá tuplas formadas pelos elementos
correspondentes de cada sequência. Isso se parece com a função ``:func:zip``,
exceto que ``:func:map`` devolve uma lista com o comprimento da sequência mais
longa que foi passada, preenchendo as lacunas com ``None`` quando necessário,
e ``:func:zip`` devolve uma lista com o comprimento da mais curta. Confira::

   >>> map(None, range(5))
   [0, 1, 2, 3, 4]
   >>> map(None, range(5), range(3))
   [(0, 0), (1, 1), (2, 2), (3, None), (4, None)]
   >>> zip(range(5), range(3))
   [(0, 0), (1, 1), (2, 2)]
   >>>

A função ``reduce(funcao, sequencia)`` devolve um único valor construído a
partir da sucessiva aplicação da função binária (N.d.T. que recebe dois
argumentos) a todos os elementos da lista fornecida, começando pelos dois
primeiros itens, depois aplicando a função ao primeiro resultado obtido e ao
próximo item, e assim por diante. Por exemplo, para computar a soma dos
inteiros de 1 a 10::

   >>> def somar(x,y): return x+y
   ...
   >>> reduce(somar, range(1, 11))
   55

Se houver um único elemento na sequência fornecida, seu valor será devolvido.
Se a sequência estiver vazia, uma exceção será levantada.

Um terceiro argumento pode ser passado para definir o valor inicial. Neste
caso, redução de uma sequência vazia debolve o valor inicial. Do contrário,
a redução se inicia aplicando a função ao valor inicial e ao primeiro elemento da sequência, e continuando a partir daí. ::

   >>> def somatoria(seq):
   ...     def somar(x,y): return x+y
   ...     return reduce(somar, seq, 0)
   ...
   >>> somatoria(range(1, 11))
   55
   >>> somatoria([])
   0

Não use a função ``somatória`` deste exemplo; somar sequências de números é uma
necessidade comum, e para isso Python tem a função embutida :func:`sum`, que
faz exatamente isto, e também aceita um valor inicial (opcional).

.. versionadded:: 2.3

List comprehensions ou abrangências de listas
---------------------------------------------

Uma *list comprehension* é uma maneira concisa de construir uma lista
preenchida. (N.d.T. literalmente, *abrangência de lista* mas no Brasil o termo
em inglês é muito usado; também se usa a abreviação *listcomp*)

Um uso comum é constuir uma nova lista onde cada elemento é o resultado de alguma
expressão aplicada a cada membro de outra sequência ou iterável, ou para construir
uma sub-sequência cujos elementos satisfazem uma certa condição.

Por exemplo, suponha que queremos criar uma lista de quadrados, assim::

   >>> quadrados = []
   >>> for x in range(10):
   ...     quadrados.append(x**2)
   ...
   >>> quadrados
   [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

Podemos obter o mesmo resultado desta forma::

   quadrados = [x**2 for x in range(10)]

Isso equivale a ``quadrados = map(lambda x: x**2, range(10))``, mas é mais
conciso e legível.

Uma abrangência de lista é formada por um par de colchetes contendo uma
expressão seguida de uma cláusula :keyword:`for`, e então zero ou mais
cláusulas :keyword:`for` ou :keyword:`if`. O resultado será uma lista
resultante da avaliação da expressão no contexto das cláusulas :keyword:`for`
e :keyword:`if`.

Por exemplo, esta listcomp combina os elementos de duas listas quando eles são
diferenttes::

   >>> [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]
   [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]

Isto equivale a:

   >>> combs = []
   >>> for x in [1,2,3]:
   ...     for y in [3,1,4]:
   ...         if x != y:
   ...             combs.append((x, y))
   ...
   >>> combs
   [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]

Note como a ordem dos :keyword:`for` e :keyword:`if` é a mesma nos dois
exemplos acima.

Se a expressão é uma tupla, ela deve ser inserida entre parênteses (ex.,
``(x, y)`` no exemplo anterior). ::

   >>> vec = [-4, -2, 0, 2, 4]
   >>> # criar uma lista com os valores dobrados
   >>> [x*2 for x in vec]
   [-8, -4, 0, 4, 8]
   >>> # filtrar a lista para excluir números negativos
   >>> [x for x in vec if x >= 0]
   [0, 2, 4]
   >>> # aplicar uma função a todos os elementos
   >>> [abs(x) for x in vec]
   [4, 2, 0, 2, 4]
   >>> # invocar um método em cada elemento
   >>> frutas = ['  banana', '  loganberry ', 'passion fruit  ']
   >>> [arma.strip() for arma in frutas]
   ['banana', 'loganberry', 'passion fruit']
   >>> # criar uma lista de duplas, ou tuplas de 2, como (numero, quadrado)
   >>> [(x, x**2) for x in range(6)]
   [(0, 0), (1, 1), (2, 4), (3, 9), (4, 16), (5, 25)]
   >>> # a tupla deve estar emtre parêntesis, do contrário ocorre um erro
   >>> [x, x**2 for x in range(6)]
     File "<stdin>", line 1
       [x, x**2 for x in range(6)]
                  ^
   SyntaxError: invalid syntax
   >>> # achatar uma lista usando uma listcomp com dois 'for'
   >>> vec = [[1,2,3], [4,5,6], [7,8,9]]
   >>> [num for elem in vec for num in elem]
   [1, 2, 3, 4, 5, 6, 7, 8, 9]

A abrangência de lista é mais flexível do que :func:`map` e pode conter expressões complexas e funções aninhadas, sem necessidade do uso de :keyword'`lambda`::

   >>> from math import pi
   >>> [str(round(pi, i)) for i in range(1, 6)]
   ['3.1', '3.14', '3.142', '3.1416', '3.14159']


Listcomps aninhadas
'''''''''''''''''''

A expressão inicial de uma listcomp pode ser uma expressão arbitrária,
inclusive outra listcomp.

Observe este exemplo de uma matriz 3x4 implementada como uma lista de
3 listas de comprimento 4::

   >>> matriz = [
   ...     [1, 2, 3, 4],
   ...     [5, 6, 7, 8],
   ...     [9, 10, 11, 12],
   ... ]

A abrangência de listas abaixo transpõe as linhas e colunas::

   >>> [[linha[i] for linha in matriz] for i in range(len(matriz[0]))]
   [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]

Como vimos na seção anterior, a listcomp aninhada é computada no contexto
da cláusula :keyword:`for` seguinte, portanto o exemplo acima equivale a::

   >>> transposta = []
   >>> for i in range(len(matriz[0])):
   ...     transposta.append([linha[i] for linha in matriz])
   ...
   >>> transposta
   [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]

e isso, por sua vez, faz o mesmo que isto::

   >>> transposta = []
   >>> for i in range(len(matriz[0])):
   ...     # as próximas 3 linhas implementam a listcomp aninhada
   ...     linha_transposta = []
   ...     for linha in matriz:
   ...         linha_transposta.append(linha[i])
   ...     transposta.append(linha_transposta)
   ...
   >>> transposta
   [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
   >>>

Na prática, você deve dar preferência a funções embutidas em vez de expressões complexas. A função :func:`zip` resolve muito bem este caso de uso::

   >>> zip(*matriz)
   [(1, 5, 9), (2, 6, 10), (3, 7, 11), (4, 8, 12)]

Veja :ref:`tut-unpacking-arguments` para entender o uso do asterísco neste exemplo.

.. _tut-del:

O comando :keyword:`del`
========================

Existe uma maneira de remover um item de uma lista conhecendo seu índice, ao
invés de seu valor: o comando :keyword:`del`. Ele difere do método
:meth:`list.pop`, que devolve o item removido. O comanddo :keyword:`del` também
pode ser utilizado para remover fatias (slices) da lista, ou mesmo limpar a
lista toda (que fizemos antes atribuindo uma lista vazia à fatia ``a[:]``). Por
exemplo::

   >>> a = [-1, 1, 66.25, 333, 333, 1234.5]
   >>> del a[0]
   >>> a
   [1, 66.25, 333, 333, 1234.5]
   >>> del a[2:4]
   >>> a
   [1, 66.25, 1234.5]
   >>> del a[:]
   >>> a
   []

:keyword:`del` também pode ser usado para remover totalmente uma variável::

   >>> del a
   >>> a
   Traceback (most recent call last):
     ...
   NameError: name 'a' is not defined

Referenciar a variável ``a`` depois de sua remoção constitui erro (pelo menos
até que seja feita uma nova atribuição para ela). Encontraremos outros
usos para o comando :keyword:`del` mais tarde.

.. _tut-tuples:

Tuplas e sequências
===================

We saw that lists and strings have many common properties, such as indexing and
slicing operations.  They are two examples of *sequence* data types (see
:ref:`typesseq`).  Since Python is an evolving language, other sequence data
types may be added.  There is also another standard sequence data type: the
*tuple*.

Vimos que listas e strings têm muitas propriedades em comum, como indexação e
operações de fatiamento (*slicing*). Elas são dois exemplos de *sequências*
(veja :ref:`typesseq`). Como Python é uma linguagem em evolução, outros tipos
de sequências podem ser adicionados. Existe ainda um outro tipo de sequência
padrão na linguagem: a tupla (*tuple*).

Uma tupla consiste em uma sequência de valores separados por vírgulas::

   >>> t = 12345, 54321, 'bom dia!'
   >>> t[0]
   12345
   >>> t
   (12345, 54321, 'bom dia!')
   >>> # Tuplas podem ser aninhadas:
   ... u = t, (1, 2, 3, 4, 5)
   >>> u
   ((12345, 54321, 'bom dia!'), (1, 2, 3, 4, 5))

Como você pode ver no trecho acima, na saída do console as tuplas são sempre
envolvidas por parênteses, assim tuplas aninhadas podem ser lidas
corretamente. Na criação, tuplas podem ser envolvidas ou não por parênteses,
desde que o contexto não exija os parênteses (como no caso da tupla dentro
a uma expressão maior).

Tuplas podem ser usadas de diversas formas: pares ordenados ``(x, y)``,
registros de funcionário extraídos uma base de dados, etc. Tuplas, assim como
strings, são imutáveis: não é possível atribuir valores a itens individuais de
uma tupla (você pode simular o mesmo efeito através de operações de fatiamento
e concatenação; N.d.T. mas neste caso nunca estará modificando tuplas, apenas
criando novas). Também é possível criar tuplas contendo objetos mutáveis,
como listas.

Um problema especial é a criação de tuplas contendo 0 ou 1 itens: a sintaxe
usa certos truques para acomodar estes casos. Tuplas vazias são construídas
por uma par de parênteses vazios; uma tupla unitária é construída por um
único valor e uma vírgula entre parênteses (não basta colocar um único valor
entre parênteses). Feio, mas funciona::

   >>> vazia = ()
   >>> upla = 'hello',    # <-- note a vírgula no final
   >>> len(vazia)
   0
   >>> len(upla)
   1
   >>> upla
   ('hello',)

O comando ``t = 12345, 54321, 'hello!'`` é um exemplo de *empacotamento de
tupla* (*tuple packing*): os valores ``12345``, ``54321`` e ``'bom dia!'`` são
empacotados juntos em uma tupla. A operação inversa também é possível::

   >>> x, y, z = t

Isto é chamado de desempacotamento de sequência (*sequence unpacking*), funciona
para qualquer tipo de sequência do lado direito. Para funcionar, é necessário
que a lista de variáveis do lado esquerdo tenha o mesmo comprimento da
sequência à direita. Sendo assim, a atribuição múltipla é um caso de
empacotamento de tupla e desempacotamento de sequência::

   >>> a, b = b, a  # troca os valores de a e b

.. N.d.T. Acrescentei o exemplo acima, e preservei o parágrafo abaixo, que não
   existe na versão atual do tutorial EN mas existe na versão 2.4 do PT-BR ~LR

Existe uma certa assimetria aqui: empacotamento de múltiplos valores sempre
cria tuplas, mas o desempacotamento funciona para qualquer sequência.

.. XXX Add a bit on the difference between tuples and lists.


.. _tut-sets:

Sets
====

Python also includes a data type for *sets*.  A set is an unordered collection
with no duplicate elements.  Basic uses include membership testing and
eliminating duplicate entries.  Set objects also support mathematical operations
like union, intersection, difference, and symmetric difference.

Here is a brief demonstration::

   >>> basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
   >>> fruit = set(basket)               # create a set without duplicates
   >>> fruit
   set(['orange', 'pear', 'apple', 'banana'])
   >>> 'orange' in fruit                 # fast membership testing
   True
   >>> 'crabgrass' in fruit
   False

   >>> # Demonstrate set operations on unique letters from two words
   ...
   >>> a = set('abracadabra')
   >>> b = set('alacazam')
   >>> a                                  # unique letters in a
   set(['a', 'r', 'b', 'c', 'd'])
   >>> a - b                              # letters in a but not in b
   set(['r', 'd', 'b'])
   >>> a | b                              # letters in either a or b
   set(['a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'])
   >>> a & b                              # letters in both a and b
   set(['a', 'c'])
   >>> a ^ b                              # letters in a or b but not both
   set(['r', 'd', 'b', 'm', 'z', 'l'])


.. _tut-dictionaries:

Dictionaries
============

Another useful data type built into Python is the *dictionary* (see
:ref:`typesmapping`). Dictionaries are sometimes found in other languages as
"associative memories" or "associative arrays".  Unlike sequences, which are
indexed by a range of numbers, dictionaries are indexed by *keys*, which can be
any immutable type; strings and numbers can always be keys.  Tuples can be used
as keys if they contain only strings, numbers, or tuples; if a tuple contains
any mutable object either directly or indirectly, it cannot be used as a key.
You can't use lists as keys, since lists can be modified in place using index
assignments, slice assignments, or methods like :meth:`append` and
:meth:`extend`.

It is best to think of a dictionary as an unordered set of *key: value* pairs,
with the requirement that the keys are unique (within one dictionary). A pair of
braces creates an empty dictionary: ``{}``. Placing a comma-separated list of
key:value pairs within the braces adds initial key:value pairs to the
dictionary; this is also the way dictionaries are written on output.

The main operations on a dictionary are storing a value with some key and
extracting the value given the key.  It is also possible to delete a key:value
pair with ``del``. If you store using a key that is already in use, the old
value associated with that key is forgotten.  It is an error to extract a value
using a non-existent key.

The :meth:`keys` method of a dictionary object returns a list of all the keys
used in the dictionary, in arbitrary order (if you want it sorted, just apply
the :func:`sorted` function to it).  To check whether a single key is in the
dictionary, use the :keyword:`in` keyword.

Here is a small example using a dictionary::

   >>> tel = {'jack': 4098, 'sape': 4139}
   >>> tel['guido'] = 4127
   >>> tel
   {'sape': 4139, 'guido': 4127, 'jack': 4098}
   >>> tel['jack']
   4098
   >>> del tel['sape']
   >>> tel['irv'] = 4127
   >>> tel
   {'guido': 4127, 'irv': 4127, 'jack': 4098}
   >>> tel.keys()
   ['guido', 'irv', 'jack']
   >>> 'guido' in tel
   True

The :func:`dict` constructor builds dictionaries directly from lists of
key-value pairs stored as tuples.  When the pairs form a pattern, list
comprehensions can compactly specify the key-value list. ::

   >>> dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
   {'sape': 4139, 'jack': 4098, 'guido': 4127}
   >>> dict([(x, x**2) for x in (2, 4, 6)])     # use a list comprehension
   {2: 4, 4: 16, 6: 36}

Later in the tutorial, we will learn about Generator Expressions which are even
better suited for the task of supplying key-values pairs to the :func:`dict`
constructor.

When the keys are simple strings, it is sometimes easier to specify pairs using
keyword arguments::

   >>> dict(sape=4139, guido=4127, jack=4098)
   {'sape': 4139, 'jack': 4098, 'guido': 4127}


.. _tut-loopidioms:

Looping Techniques
==================

When looping through dictionaries, the key and corresponding value can be
retrieved at the same time using the :meth:`iteritems` method. ::

   >>> knights = {'gallahad': 'the pure', 'robin': 'the brave'}
   >>> for k, v in knights.iteritems():
   ...     print k, v
   ...
   gallahad the pure
   robin the brave

When looping through a sequence, the position index and corresponding value can
be retrieved at the same time using the :func:`enumerate` function. ::

   >>> for i, v in enumerate(['tic', 'tac', 'toe']):
   ...     print i, v
   ...
   0 tic
   1 tac
   2 toe

To loop over two or more sequences at the same time, the entries can be paired
with the :func:`zip` function. ::

   >>> questions = ['name', 'quest', 'favorite color']
   >>> answers = ['lancelot', 'the holy grail', 'blue']
   >>> for q, a in zip(questions, answers):
   ...     print 'What is your {0}?  It is {1}.'.format(q, a)
   ...
   What is your name?  It is lancelot.
   What is your quest?  It is the holy grail.
   What is your favorite color?  It is blue.

To loop over a sequence in reverse, first specify the sequence in a forward
direction and then call the :func:`reversed` function. ::

   >>> for i in reversed(xrange(1,10,2)):
   ...     print i
   ...
   9
   7
   5
   3
   1

To loop over a sequence in sorted order, use the :func:`sorted` function which
returns a new sorted list while leaving the source unaltered. ::

   >>> basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
   >>> for f in sorted(set(basket)):
   ...     print f
   ...
   apple
   banana
   orange
   pear


.. _tut-conditions:

More on Conditions
==================

The conditions used in ``while`` and ``if`` statements can contain any
operators, not just comparisons.

The comparison operators ``in`` and ``not in`` check whether a value occurs
(does not occur) in a sequence.  The operators ``is`` and ``is not`` compare
whether two objects are really the same object; this only matters for mutable
objects like lists.  All comparison operators have the same priority, which is
lower than that of all numerical operators.

Comparisons can be chained.  For example, ``a < b == c`` tests whether ``a`` is
less than ``b`` and moreover ``b`` equals ``c``.

Comparisons may be combined using the Boolean operators ``and`` and ``or``, and
the outcome of a comparison (or of any other Boolean expression) may be negated
with ``not``.  These have lower priorities than comparison operators; between
them, ``not`` has the highest priority and ``or`` the lowest, so that ``A and
not B or C`` is equivalent to ``(A and (not B)) or C``. As always, parentheses
can be used to express the desired composition.

The Boolean operators ``and`` and ``or`` are so-called *short-circuit*
operators: their arguments are evaluated from left to right, and evaluation
stops as soon as the outcome is determined.  For example, if ``A`` and ``C`` are
true but ``B`` is false, ``A and B and C`` does not evaluate the expression
``C``.  When used as a general value and not as a Boolean, the return value of a
short-circuit operator is the last evaluated argument.

It is possible to assign the result of a comparison or other Boolean expression
to a variable.  For example, ::

   >>> string1, string2, string3 = '', 'Trondheim', 'Hammer Dance'
   >>> non_null = string1 or string2 or string3
   >>> non_null
   'Trondheim'

Note that in Python, unlike C, assignment cannot occur inside expressions. C
programmers may grumble about this, but it avoids a common class of problems
encountered in C programs: typing ``=`` in an expression when ``==`` was
intended.


.. _tut-comparing:

Comparing Sequences and Other Types
===================================

Sequence objects may be compared to other objects with the same sequence type.
The comparison uses *lexicographical* ordering: first the first two items are
compared, and if they differ this determines the outcome of the comparison; if
they are equal, the next two items are compared, and so on, until either
sequence is exhausted. If two items to be compared are themselves sequences of
the same type, the lexicographical comparison is carried out recursively.  If
all items of two sequences compare equal, the sequences are considered equal.
If one sequence is an initial sub-sequence of the other, the shorter sequence is
the smaller (lesser) one.  Lexicographical ordering for strings uses the ASCII
ordering for individual characters.  Some examples of comparisons between
sequences of the same type::

   (1, 2, 3)              < (1, 2, 4)
   [1, 2, 3]              < [1, 2, 4]
   'ABC' < 'C' < 'Pascal' < 'Python'
   (1, 2, 3, 4)           < (1, 2, 4)
   (1, 2)                 < (1, 2, -1)
   (1, 2, 3)             == (1.0, 2.0, 3.0)
   (1, 2, ('aa', 'ab'))   < (1, 2, ('abc', 'a'), 4)

Note that comparing objects of different types is legal.  The outcome is
deterministic but arbitrary: the types are ordered by their name. Thus, a list
is always smaller than a string, a string is always smaller than a tuple, etc.
[#]_ Mixed numeric types are compared according to their numeric value, so 0
equals 0.0, etc.


.. rubric:: Footnotes

.. [#] The rules for comparing objects of different types should not be relied upon;
   they may change in a future version of the language.

