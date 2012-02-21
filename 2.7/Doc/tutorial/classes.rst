.. _tut-classes:

*******
Classes
*******

Em comparação com outras linguages, o mecanismo de classes de Python introduz
a programação orientada a objetos sem acrescentar muitas novidades de sintaxe
ou semântica. É uma mistura de mecanismos equivalentes encontrados em C++ e
Modula-3. As classes em Python oferecem todas as características tradicionais
da programação a orientada a objetos: o mecanismo de herança permite múltiplas
classes base (herança múltipla), uma classe derivada pode sobrescrever
quaisquer métodos de uma classe ancestral, e um método pode invocar outro
método homônimo de uma classe ancestral. Objetos podem armazenar uma
quantidade arbitrária de dados de qualquer tipo. Assim como acontece com os
módulos, as classes fazem parte da natureza dinâmica de Python: são criadas em
tempo de execução, e podem ser alteradas após sua criação.

Usando a terminologia de C++, todos os membros de uma classe (incluindo dados)
são públicos, e todos as funções membro são virtuais. Como em Modula-3, não
existem atalhos para referenciar membros do objeto de dentro dos seus métodos.
Um método (função definida em uma classe) é declarado com um primeiro
argumento explícito representando o objeto (instância da classe), que é
fornecido implicitamente pela invocação. Como em Smalltalk, classes são
objetos. Isso fornece uma semântica para importar e renomear. Ao contrário de
C++ ou Modula-3, tipos pré-definidos podem ser utilizados como classes base
para extensões de usuário por herança. Como em C++, mas diferentemente de
Modula-3, a maioria dos operadores (aritiméticos, indexação,etc) podem ser
redefinidos para instâncias de classe.

(Na falta de uma terminologia universalmente aceita para falar sobre classes,
ocasionalmente farei uso de termos comuns em Smalltalk ou C++ (eu usaria
termos de Modula-3, já que sua semântica é mais próxima a de Python, mas creio
que poucos leitores já ouviram falar dessa linguagem.)


.. _tut-object:

Uma palavra sobre nomes e objetos
=================================

Objetos têm individualidade, e vários nomes (inclusive em diferentes escopos)
podem estar vinculados a um mesmo objeto. Isso é chamado de *aliasing* em
outras linguagens. (N.d.T. *aliasing* é, literalmente, "apelidamento": um
mesmo objeto pode ter vários apelidos.) À primeira vista, esta característica
não é muito apreciada, e pode ser seguramente ignorada ao lidar com tipos
imutáveis (números, strings, tuplas). Entretanto, aliasing pode ter um efeito
inesperado sobre a semântica de código Python envolvendo objetos mutáveis como
listas, dicionários e a maioria dos outros tipos. Isso pode ser usado em
benefício do programa, porque os aliases (apelidos) funcionam de certa forma
como ponteiros. Por exemplo, passar um objeto como argumento é barato, pois só
um ponteiro é passado na implementação; e se uma função modifica um objeto
passado como argumento, o invocador verá a mudança --- isso elimina a
necessidade de ter dois mecanismos de passagem de parâmetros como em Pascal.

N.d.T. Na terminologia de C++ e Java, o que o parágrafo acima denomina
"apelidos" são identificadores de referências (variáveis de referência), e os
ponteiros são as próprias referências. Se uma variável ``a`` está associada a
um objeto qualquer, informalmente dizemos que a variável "contém" o objeto,
mas na realidade o objeto existe independente da variável, e o conteúdo da
variável é apenas uma referência (um ponteiro) para o objeto. O *aliasing*
ocorre quando existem diversas variáveis, digamos ``a``, ``b`` e ``c``,
apontando para o mesmo objeto.

.. _tut-scopes:

Escopos e *namespaces*
======================

Antes de introduzir classes, é preciso falar das regras de escopo em Python.
Definições de classe fazem alguns truques com *namespaces* (espaços de nomes).
Portanto, primeiro é preciso entender bem como escopos e *namespaces*
funcionam. Esse conhecimento é muito útil para o programador avançado em
Python.

Vamos começar com algumas definições.

Um *namespace* (ou espaço de nomes) é um mapeamento que associa nomes a
objetos. Atualmente, são implementados como dicionários em Python, mas isso
não é perceptível (a não ser pelo desempenho), e pode mudar no futuro.
Exemplos de espaços de nomes são: o conjunto de nomes pré-definidos (funções
como :func:`abs` e as exceções embutidas); nomes globais em um módulo; e nomes
locais na invocação de uma função. De uma certa forma, os atributos de um
objeto também formam um espaço de nomes. O mais importante é saber que não
existe nenhuma relação entre nomes em espaços distintos. Por exemplo, dois
módulos podem definir uma função de nome ``maximize`` sem confusão ---
usuários dos módulos devem prefixar a função com o nome do módulo para evitar
colisão.

A propósito, utilizo a palavra *atributo* para qualquer nome depois de um
ponto. Na expressão ``z.real``, por exemplo, ``real`` é um atributo do objeto
``z``. Estritamente falando, referências para nomes em módulos são atributos:
na expressão ``nomemod.nomefunc``, ``nomemod`` é um objeto módulo e
``nomefunc`` é um de seus atributos. Neste caso, existe um mapeamento direto
entre os os atributos de um módulo e os nomes globais definidos no módulo:
eles compartilham o mesmo espaço de nomes! [#]_

Atributos podem ser somente para leitura ou para leitura e escrita. No segundo
caso, é possível atribuir um novo valor ao atributo. (N.d.T. Ou mesmo criar
novos atributos.) Atributos de módulos são passíveis de atribuição: você pode
escrever ``nomemod.a_reposta = 42``. Atributos que aceitam escrita também
podem ser apagados através do comando :keyword:`del`. Por exemplo, ``del
nomemod.a_reposta`` remove o atributo :attr:`a_resposta` do objeto
referenciado por ``nomemod``.

Espaços de nomes são criados em momentos diferentes e possuem diferentes
ciclos de vida. O espaço de nomes que contém os nomes embutidos é criado
quando o interpretador inicializa e nunca é removido. O espaço de nomes global
de um módulo é criado quando a definição do módulo é lida, e normalmente duram
até a terminação do interpretador. Os comandos executados pela invocação do
interpertador, pela leitura de um script com programa principal, ou
interativamente, são parte do módulo chamado :mod:`__main__`, e portanto
possuem seu próprio espaço de nomes. (Os nomes embutidos possuem seu
próprio espaço de nomes no módulo chamado :mod:`__builtin__`.).

O espaço de nomes local de uma função é criado quando a função é invocada, e
apagado quando a função retorna ou levanta uma exceção que não é tratada na
própria função. (Na verdade, uma forma melhor de descrever o que realmente
acontece é que o espaço de nomes local é "esquecido" quando a funçao termina.)
Naturalmente, cada invocação recursiva de uma função tem seu próprio espaço de
nomes.

Um *escopo* (*scope*) é uma região textual de um programa Python onde um
espaço de nomes é diretamente acessível. Aqui, “diretamente acessível”
significa que uma referência sem um prefixo qualificador permite o acesso ao
nome.

Ainda que escopos sejam determinados estaticamente, eles são usados
dinamicamente. A qualquer momento durante a execução, existem no mínimo três
escopos diretamente acessíveis:

* o escopo mais interno (que é acessado primeiro) contendo nomes locais;
* os escopos das funções que envolvem a função atual, que são acessados a
  partir do escopo mias próximo, contém nomes não-locais mas também
  não-globais;
* o penúltimo escopo contém os nomes globais do módulo atual;
* e o escopo mais externo (acessado por último) contém os nomes das funções
  embutidas e demais objetos pré-definidos do interpretador.

Se um nome é declarado no escopo global, então todas as referências e
atribuições valores vão diretamente para o escopo intermediário que contém os
nomes globais do módulo. Caso contrário, todas as variáveis encontradas fora
do escopo mais interno são apenas para leitura (a tentativa de atribuir
valores a essas variáveis irá simplesmente criar uma *nova* variável local, no
escopo interno, não alterando nada na variável de nome idêntico fora dele).

Normalmente, o escopo local referencia os nomes locais da função corrente no
texto do programa. Fora de funções, o escopo local referencia os nomes do
escopo global: espaço de nomes do módulo. Definições de classes adicionam um
outro espaço de nomes ao escopo local.

É importante perceber que escopos são determinados estaticamente, pelo texto
do código fonte: o escopo global de uma função definida em um módulo é o
espaço de nomes deste módulo, sem importar de onde ou por qual apelido a
função é invocada. Por outro lado, a busca de nomes é dinâmica, ocorrendo
durante a execução. Porém, a evolução da linguagem está caminhando para uma
resolução de nomes estática, em "tempo de compilação" (N.d.T. quando um módulo
é carregado ele é compilado em memória), portanto não conte com a resolução
dinâmica de nomes! (De fato, variáveis locais já são resolvidas
estaticamente.)

Uma peculiaridade de Python é que atribuições ocorrem sempre no escopo mais
interno, exceto quando o comando :keyword:`global` é usado. Atribuições não
copiam dados, apenas associam nomes a objetos. O mesmo vale para remoções: o
comando ``del x`` remove o vínculo de ``x`` do espaço de nomes do escopo
local. De fato, todas as operações que introduzem novos nomes usam o escopo
local. Em particular, instruções :keyword:`import` e definições de funções
assoociam o nome módulo ou da função ao escopo local. (A palavra-reservada
:keyword:`global` pode ser usada para indicar que certas variáveis residem no
escopo global ao invés do local.)


.. _tut-firstclasses:

Primeiro contato com classes
============================

Classes introduzem novidades sintáticas, três novos tipos de objetos, e também
alguma semântica nova.


.. _tut-classdefinition:

Sintaxe de definição de classe
------------------------------

A forma mais simples de definir uma classe é:::

   class NomeDaClasse:
       <instrução-1>
       .
       .
       .
       <instrução-N>

Definições de classes, assim como definições de funções (instruções
:keyword:`def`), precisam ser executados antes que tenham qualquer efeito.
(Por exemplo, você pode colocar uma definição de classe dentro de teste
condicional :keyword:`if` ou dentro de uma função.)

Na prática, as instruções dentro da definição de uma classe em geral serão
definições de funções, mas outras instruções são permitidas, e às vezes são
bem úteis --- voltaremos a este tema depois. Definições de funções dentro da
classe normalmente têm um lista peculiar de parâmetros formais determinada
pela convenção de chamada a métodos --- isso também será explicado mais tarde.

Quando se inicia a definição de classe, um novo namespace é criado, e usado
como escopo local --- assim, todas atribuições a variáveis locais ocorrem
nesse namespace. Em particular, funções definidas aqui são vinculadas a nomes
nesse escopo.

Quando o processamento de uma definição de classe é completado (normalmente,
sem erros), um *objeto classe* é criado. Este objeto encapsula o conteúdo do
espaço de nomes criado pela definição da class; aprenderemos mais sobre
objetos classe na próxima seção. O escopo local que estava vigente antes da
definição da classe é reativado, e o objeto classe é vinculado ao
identificador da classe nesse escopo (no exemplo acima, :class:`NomeDaClasse`
é o identificador da classe).


.. _tut-classobjects:

Objetos classe
--------------

Objetos classe suportam dois tipos de operações: *referências a atributos* e
*instanciação*.

*Referências a atributos* de classe utilizam a sintaxe padrão utilizada para
quaisquer referências a atributos em Python: ``obj.nome``. Atributos válidos
são todos os nomes presentes dentro do namespace da classe quando o objeto
classe foi criado. Portanto, se a definição da classe foi assim::


   class MinhaClasse:
       """Um exemplo simples de classe"""
       i = 12345
       def f(self):
           return 'olá, mundo'

então ``MinhaClasse.i`` e ``MinhaClasse.f`` são referências válidas, que
acessam, respectivamente, um inteiro e um objeto função. É possível mudar os
valores dos atributos da classe, ou mesmo criar novos atributos, fazendo uma
atribuição simples assim: ``MinhaClasse.i = 10``. O nome ``__doc__``
identifica outro atributo válido da classe, referenciando a *docstring*
associada à classe: ``"Um exemplo simples de classe"``.

Para *instanciar* uma classe, usa-se a sintaxe de invocar uma função. Apenas
finja que o objeto classe do exemplo é uma função sem parâmetros, que devolve
uma nova instância da classe. Continuando o exemplo acima::

   x = MinhaClasse()

cria uma nova *instância* da classe e atribui o objeto resultante à variável
local ``x``.

A operação de instanciação (“invocar” um objeto classe) cria um objeto vazio.
Muitas classes preferem criar novos objetos com um estado inicial
predeterminado. Para tanto, a classe pode definir um método especial
chamado :meth:`__init__`, assim::

   def __init__(self):
       self.dados = []

Quando uma classe define um método :meth:`__init__`, o processo de
instânciação automaticamente invoca :meth:`__init__` sobre a instância recém
criada. Em nosso exemplo, uma nova intância já inicializada pode ser obtida
por::

   x = MinhaClasse()

Naturalmente, o método :meth:`__init__` pode ter parâmetros para maior
flexibilidade. Neste caso, os argumentos fornecidos na invocação da classe
serão passados para o método :meth:`__init__`. Por exemplo::

   >>> class Complexo:
   ...     def __init__(self, parte_real, parte_imag):
   ...         self.r = parte_real
   ...         self.i = parte_imag
   ...
   >>> x = Complexo(3.0, -4.5)
   >>> x.r, x.i
   (3.0, -4.5)


.. _tut-instanceobjects:

Instance Objects
----------------

Now what can we do with instance objects?  The only operations understood by
instance objects are attribute references.  There are two kinds of valid
attribute names, data attributes and methods.

*data attributes* correspond to "instance variables" in Smalltalk, and to "data
members" in C++.  Data attributes need not be declared; like local variables,
they spring into existence when they are first assigned to.  For example, if
``x`` is the instance of :class:`MyClass` created above, the following piece of
code will print the value ``16``, without leaving a trace::

   x.counter = 1
   while x.counter < 10:
       x.counter = x.counter * 2
   print x.counter
   del x.counter

The other kind of instance attribute reference is a *method*. A method is a
function that "belongs to" an object.  (In Python, the term method is not unique
to class instances: other object types can have methods as well.  For example,
list objects have methods called append, insert, remove, sort, and so on.
However, in the following discussion, we'll use the term method exclusively to
mean methods of class instance objects, unless explicitly stated otherwise.)

.. index:: object: method

Valid method names of an instance object depend on its class.  By definition,
all attributes of a class that are function  objects define corresponding
methods of its instances.  So in our example, ``x.f`` is a valid method
reference, since ``MyClass.f`` is a function, but ``x.i`` is not, since
``MyClass.i`` is not.  But ``x.f`` is not the same thing as ``MyClass.f`` --- it
is a *method object*, not a function object.


.. _tut-methodobjects:

Method Objects
--------------

Usually, a method is called right after it is bound::

   x.f()

In the :class:`MyClass` example, this will return the string ``'hello world'``.
However, it is not necessary to call a method right away: ``x.f`` is a method
object, and can be stored away and called at a later time.  For example::

   xf = x.f
   while True:
       print xf()

will continue to print ``hello world`` until the end of time.

What exactly happens when a method is called?  You may have noticed that
``x.f()`` was called without an argument above, even though the function
definition for :meth:`f` specified an argument.  What happened to the argument?
Surely Python raises an exception when a function that requires an argument is
called without any --- even if the argument isn't actually used...

Actually, you may have guessed the answer: the special thing about methods is
that the object is passed as the first argument of the function.  In our
example, the call ``x.f()`` is exactly equivalent to ``MyClass.f(x)``.  In
general, calling a method with a list of *n* arguments is equivalent to calling
the corresponding function with an argument list that is created by inserting
the method's object before the first argument.

If you still don't understand how methods work, a look at the implementation can
perhaps clarify matters.  When an instance attribute is referenced that isn't a
data attribute, its class is searched.  If the name denotes a valid class
attribute that is a function object, a method object is created by packing
(pointers to) the instance object and the function object just found together in
an abstract object: this is the method object.  When the method object is called
with an argument list, a new argument list is constructed from the instance
object and the argument list, and the function object is called with this new
argument list.


.. _tut-remarks:

Random Remarks
==============

.. These should perhaps be placed more carefully...

Data attributes override method attributes with the same name; to avoid
accidental name conflicts, which may cause hard-to-find bugs in large programs,
it is wise to use some kind of convention that minimizes the chance of
conflicts.  Possible conventions include capitalizing method names, prefixing
data attribute names with a small unique string (perhaps just an underscore), or
using verbs for methods and nouns for data attributes.

Data attributes may be referenced by methods as well as by ordinary users
("clients") of an object.  In other words, classes are not usable to implement
pure abstract data types.  In fact, nothing in Python makes it possible to
enforce data hiding --- it is all based upon convention.  (On the other hand,
the Python implementation, written in C, can completely hide implementation
details and control access to an object if necessary; this can be used by
extensions to Python written in C.)

Clients should use data attributes with care --- clients may mess up invariants
maintained by the methods by stamping on their data attributes.  Note that
clients may add data attributes of their own to an instance object without
affecting the validity of the methods, as long as name conflicts are avoided ---
again, a naming convention can save a lot of headaches here.

There is no shorthand for referencing data attributes (or other methods!) from
within methods.  I find that this actually increases the readability of methods:
there is no chance of confusing local variables and instance variables when
glancing through a method.

Often, the first argument of a method is called ``self``.  This is nothing more
than a convention: the name ``self`` has absolutely no special meaning to
Python.  Note, however, that by not following the convention your code may be
less readable to other Python programmers, and it is also conceivable that a
*class browser* program might be written that relies upon such a convention.

Any function object that is a class attribute defines a method for instances of
that class.  It is not necessary that the function definition is textually
enclosed in the class definition: assigning a function object to a local
variable in the class is also ok.  For example::

   # Function defined outside the class
   def f1(self, x, y):
       return min(x, x+y)

   class C:
       f = f1
       def g(self):
           return 'hello world'
       h = g

Now ``f``, ``g`` and ``h`` are all attributes of class :class:`C` that refer to
function objects, and consequently they are all methods of instances of
:class:`C` --- ``h`` being exactly equivalent to ``g``.  Note that this practice
usually only serves to confuse the reader of a program.

Methods may call other methods by using method attributes of the ``self``
argument::

   class Bag:
       def __init__(self):
           self.data = []
       def add(self, x):
           self.data.append(x)
       def addtwice(self, x):
           self.add(x)
           self.add(x)

Methods may reference global names in the same way as ordinary functions.  The
global scope associated with a method is the module containing its
definition.  (A class is never used as a global scope.)  While one
rarely encounters a good reason for using global data in a method, there are
many legitimate uses of the global scope: for one thing, functions and modules
imported into the global scope can be used by methods, as well as functions and
classes defined in it.  Usually, the class containing the method is itself
defined in this global scope, and in the next section we'll find some good
reasons why a method would want to reference its own class.

Each value is an object, and therefore has a *class* (also called its *type*).
It is stored as ``object.__class__``.


.. _tut-inheritance:

Inheritance
===========

Of course, a language feature would not be worthy of the name "class" without
supporting inheritance.  The syntax for a derived class definition looks like
this::

   class DerivedClassName(BaseClassName):
       <statement-1>
       .
       .
       .
       <statement-N>

The name :class:`BaseClassName` must be defined in a scope containing the
derived class definition.  In place of a base class name, other arbitrary
expressions are also allowed.  This can be useful, for example, when the base
class is defined in another module::

   class DerivedClassName(modname.BaseClassName):

Execution of a derived class definition proceeds the same as for a base class.
When the class object is constructed, the base class is remembered.  This is
used for resolving attribute references: if a requested attribute is not found
in the class, the search proceeds to look in the base class.  This rule is
applied recursively if the base class itself is derived from some other class.

There's nothing special about instantiation of derived classes:
``DerivedClassName()`` creates a new instance of the class.  Method references
are resolved as follows: the corresponding class attribute is searched,
descending down the chain of base classes if necessary, and the method reference
is valid if this yields a function object.

Derived classes may override methods of their base classes.  Because methods
have no special privileges when calling other methods of the same object, a
method of a base class that calls another method defined in the same base class
may end up calling a method of a derived class that overrides it.  (For C++
programmers: all methods in Python are effectively ``virtual``.)

An overriding method in a derived class may in fact want to extend rather than
simply replace the base class method of the same name. There is a simple way to
call the base class method directly: just call ``BaseClassName.methodname(self,
arguments)``.  This is occasionally useful to clients as well.  (Note that this
only works if the base class is accessible as ``BaseClassName`` in the global
scope.)

Python has two built-in functions that work with inheritance:

* Use :func:`isinstance` to check an instance's type: ``isinstance(obj, int)``
  will be ``True`` only if ``obj.__class__`` is :class:`int` or some class
  derived from :class:`int`.

* Use :func:`issubclass` to check class inheritance: ``issubclass(bool, int)``
  is ``True`` since :class:`bool` is a subclass of :class:`int`.  However,
  ``issubclass(unicode, str)`` is ``False`` since :class:`unicode` is not a
  subclass of :class:`str` (they only share a common ancestor,
  :class:`basestring`).



.. _tut-multiple:

Multiple Inheritance
--------------------

Python supports a limited form of multiple inheritance as well.  A class
definition with multiple base classes looks like this::

   class DerivedClassName(Base1, Base2, Base3):
       <statement-1>
       .
       .
       .
       <statement-N>

For old-style classes, the only rule is depth-first, left-to-right.  Thus, if an
attribute is not found in :class:`DerivedClassName`, it is searched in
:class:`Base1`, then (recursively) in the base classes of :class:`Base1`, and
only if it is not found there, it is searched in :class:`Base2`, and so on.

(To some people breadth first --- searching :class:`Base2` and :class:`Base3`
before the base classes of :class:`Base1` --- looks more natural.  However, this
would require you to know whether a particular attribute of :class:`Base1` is
actually defined in :class:`Base1` or in one of its base classes before you can
figure out the consequences of a name conflict with an attribute of
:class:`Base2`.  The depth-first rule makes no differences between direct and
inherited attributes of :class:`Base1`.)

For :term:`new-style class`\es, the method resolution order changes dynamically
to support cooperative calls to :func:`super`.  This approach is known in some
other multiple-inheritance languages as call-next-method and is more powerful
than the super call found in single-inheritance languages.

With new-style classes, dynamic ordering is necessary because all  cases of
multiple inheritance exhibit one or more diamond relationships (where at
least one of the parent classes can be accessed through multiple paths from the
bottommost class).  For example, all new-style classes inherit from
:class:`object`, so any case of multiple inheritance provides more than one path
to reach :class:`object`.  To keep the base classes from being accessed more
than once, the dynamic algorithm linearizes the search order in a way that
preserves the left-to-right ordering specified in each class, that calls each
parent only once, and that is monotonic (meaning that a class can be subclassed
without affecting the precedence order of its parents).  Taken together, these
properties make it possible to design reliable and extensible classes with
multiple inheritance.  For more detail, see
http://www.python.org/download/releases/2.3/mro/.


.. _tut-private:

Private Variables
=================

"Private" instance variables that cannot be accessed except from inside an
object don't exist in Python.  However, there is a convention that is followed
by most Python code: a name prefixed with an underscore (e.g. ``_spam``) should
be treated as a non-public part of the API (whether it is a function, a method
or a data member).  It should be considered an implementation detail and subject
to change without notice.

Since there is a valid use-case for class-private members (namely to avoid name
clashes of names with names defined by subclasses), there is limited support for
such a mechanism, called :dfn:`name mangling`.  Any identifier of the form
``__spam`` (at least two leading underscores, at most one trailing underscore)
is textually replaced with ``_classname__spam``, where ``classname`` is the
current class name with leading underscore(s) stripped.  This mangling is done
without regard to the syntactic position of the identifier, as long as it
occurs within the definition of a class.

Name mangling is helpful for letting subclasses override methods without
breaking intraclass method calls.  For example::

   class Mapping:
       def __init__(self, iterable):
           self.items_list = []
           self.__update(iterable)

       def update(self, iterable):
           for item in iterable:
               self.items_list.append(item)

       __update = update   # private copy of original update() method

   class MappingSubclass(Mapping):

       def update(self, keys, values):
           # provides new signature for update()
           # but does not break __init__()
           for item in zip(keys, values):
               self.items_list.append(item)

Note that the mangling rules are designed mostly to avoid accidents; it still is
possible to access or modify a variable that is considered private.  This can
even be useful in special circumstances, such as in the debugger.

Notice that code passed to ``exec``, ``eval()`` or ``execfile()`` does not
consider the classname of the invoking  class to be the current class; this is
similar to the effect of the  ``global`` statement, the effect of which is
likewise restricted to  code that is byte-compiled together.  The same
restriction applies to ``getattr()``, ``setattr()`` and ``delattr()``, as well
as when referencing ``__dict__`` directly.


.. _tut-odds:

Odds and Ends
=============

Sometimes it is useful to have a data type similar to the Pascal "record" or C
"struct", bundling together a few named data items.  An empty class definition
will do nicely::

   class Employee:
       pass

   john = Employee() # Create an empty employee record

   # Fill the fields of the record
   john.name = 'John Doe'
   john.dept = 'computer lab'
   john.salary = 1000

A piece of Python code that expects a particular abstract data type can often be
passed a class that emulates the methods of that data type instead.  For
instance, if you have a function that formats some data from a file object, you
can define a class with methods :meth:`read` and :meth:`readline` that get the
data from a string buffer instead, and pass it as an argument.

.. (Unfortunately, this technique has its limitations: a class can't define
   operations that are accessed by special syntax such as sequence subscripting
   or arithmetic operators, and assigning such a "pseudo-file" to sys.stdin will
   not cause the interpreter to read further input from it.)

Instance method objects have attributes, too: ``m.im_self`` is the instance
object with the method :meth:`m`, and ``m.im_func`` is the function object
corresponding to the method.


.. _tut-exceptionclasses:

Exceptions Are Classes Too
==========================

User-defined exceptions are identified by classes as well.  Using this mechanism
it is possible to create extensible hierarchies of exceptions.

There are two new valid (semantic) forms for the :keyword:`raise` statement::

   raise Class, instance

   raise instance

In the first form, ``instance`` must be an instance of :class:`Class` or of a
class derived from it.  The second form is a shorthand for::

   raise instance.__class__, instance

A class in an :keyword:`except` clause is compatible with an exception if it is
the same class or a base class thereof (but not the other way around --- an
except clause listing a derived class is not compatible with a base class).  For
example, the following code will print B, C, D in that order::

   class B:
       pass
   class C(B):
       pass
   class D(C):
       pass

   for c in [B, C, D]:
       try:
           raise c()
       except D:
           print "D"
       except C:
           print "C"
       except B:
           print "B"

Note that if the except clauses were reversed (with ``except B`` first), it
would have printed B, B, B --- the first matching except clause is triggered.

When an error message is printed for an unhandled exception, the exception's
class name is printed, then a colon and a space, and finally the instance
converted to a string using the built-in function :func:`str`.


.. _tut-iterators:

Iterators
=========

By now you have probably noticed that most container objects can be looped over
using a :keyword:`for` statement::

   for element in [1, 2, 3]:
       print element
   for element in (1, 2, 3):
       print element
   for key in {'one':1, 'two':2}:
       print key
   for char in "123":
       print char
   for line in open("myfile.txt"):
       print line

This style of access is clear, concise, and convenient.  The use of iterators
pervades and unifies Python.  Behind the scenes, the :keyword:`for` statement
calls :func:`iter` on the container object.  The function returns an iterator
object that defines the method :meth:`next` which accesses elements in the
container one at a time.  When there are no more elements, :meth:`next` raises a
:exc:`StopIteration` exception which tells the :keyword:`for` loop to terminate.
This example shows how it all works::

   >>> s = 'abc'
   >>> it = iter(s)
   >>> it
   <iterator object at 0x00A1DB50>
   >>> it.next()
   'a'
   >>> it.next()
   'b'
   >>> it.next()
   'c'
   >>> it.next()
   Traceback (most recent call last):
     File "<stdin>", line 1, in ?
       it.next()
   StopIteration

Having seen the mechanics behind the iterator protocol, it is easy to add
iterator behavior to your classes.  Define an :meth:`__iter__` method which
returns an object with a :meth:`next` method.  If the class defines
:meth:`next`, then :meth:`__iter__` can just return ``self``::

   class Reverse:
       """Iterator for looping over a sequence backwards."""
       def __init__(self, data):
           self.data = data
           self.index = len(data)
       def __iter__(self):
           return self
       def next(self):
           if self.index == 0:
               raise StopIteration
           self.index = self.index - 1
           return self.data[self.index]

::

   >>> rev = Reverse('spam')
   >>> iter(rev)
   <__main__.Reverse object at 0x00A1DB50>
   >>> for char in rev:
   ...     print char
   ...
   m
   a
   p
   s


.. _tut-generators:

Generators
==========

:term:`Generator`\s are a simple and powerful tool for creating iterators.  They
are written like regular functions but use the :keyword:`yield` statement
whenever they want to return data.  Each time :meth:`next` is called, the
generator resumes where it left-off (it remembers all the data values and which
statement was last executed).  An example shows that generators can be trivially
easy to create::

   def reverse(data):
       for index in range(len(data)-1, -1, -1):
           yield data[index]

::

   >>> for char in reverse('golf'):
   ...     print char
   ...
   f
   l
   o
   g

Anything that can be done with generators can also be done with class based
iterators as described in the previous section.  What makes generators so
compact is that the :meth:`__iter__` and :meth:`next` methods are created
automatically.

Another key feature is that the local variables and execution state are
automatically saved between calls.  This made the function easier to write and
much more clear than an approach using instance variables like ``self.index``
and ``self.data``.

In addition to automatic method creation and saving program state, when
generators terminate, they automatically raise :exc:`StopIteration`. In
combination, these features make it easy to create iterators with no more effort
than writing a regular function.


.. _tut-genexps:

Generator Expressions
=====================

Some simple generators can be coded succinctly as expressions using a syntax
similar to list comprehensions but with parentheses instead of brackets.  These
expressions are designed for situations where the generator is used right away
by an enclosing function.  Generator expressions are more compact but less
versatile than full generator definitions and tend to be more memory friendly
than equivalent list comprehensions.

Examples::

   >>> sum(i*i for i in range(10))                 # sum of squares
   285

   >>> xvec = [10, 20, 30]
   >>> yvec = [7, 5, 3]
   >>> sum(x*y for x,y in zip(xvec, yvec))         # dot product
   260

   >>> from math import pi, sin
   >>> sine_table = dict((x, sin(x*pi/180)) for x in range(0, 91))

   >>> unique_words = set(word  for line in page  for word in line.split())

   >>> valedictorian = max((student.gpa, student.name) for student in graduates)

   >>> data = 'golf'
   >>> list(data[i] for i in range(len(data)-1,-1,-1))
   ['f', 'l', 'o', 'g']



.. rubric:: Footnotes

.. [#] Except for one thing.  Module objects have a secret read-only attribute called
   :attr:`__dict__` which returns the dictionary used to implement the module's
   namespace; the name :attr:`__dict__` is an attribute but not a global name.
   Obviously, using this violates the abstraction of namespace implementation, and
   should be restricted to things like post-mortem debuggers.

