.. _tut-modules:

*******
Módulos
*******

Se você sair do interpretador do Python e voltar depois, as definições (funções 
e variáveis) que você havia feito estarão perdidas. Portanto, se você quer 
escrever um programa um pouco mais longo, você se sairá melhor usando um editor
de texto para criar e salvar o programa em um arquivo, usando depois esse 
arquivo como entrada para a execução do interpretador. Isso é conhecido como 
*script*. Como seu programa é mais longo, você pode querer dividi-lo em diversos
arquivos para tornar a manutenção mais fácil. Você também pode querer usar uma 
função que escreveu em diversos programas sem precisar copiá-la para dentro de 
cada programa.

Para permitir isso, Python tem uma maneira de colocar definições em um arquivo e
e então usá-las em um script ou em uma execução interativa no interpretador. Tal
arquivo é chamado de "módulo"; definições de um módulo podem ser *importadas* 
em outros módulos ou no módulo *principal* (a coleção de variáveis que você 
acessou para executar um script no capítulo anterior e no modo calculadora).

Um módulo é um arquivo Python contendo definições e instruções. O nome do arquivo
é o módulo com o sufixo :file:`.py` adicionado. Dentro de um módulo, o nome do 
módulo (como uma string) está disponível na variável global ``__name__``. Por 
exemplo, use seu editor de texto favorito para criar um arquivo chamado 
:file:`fibo.py` no diretório atual com o seguinte conteúdo::

   # Módulo numeros de Fibonacci

   def fib(n):    # escreve a série de Fibonacci de 0 até n
       a, b = 0, 1
       while b < n:
           print b,
           a, b = b, a+b

   def fib2(n): # returna a série de Fibonacci de 0 até n
       resultado = []
       a, b = 0, 1
       while b < n:
           resultado.append(b)
           a, b = b, a+b
       return resultado

Agora, entre no interpretador Python e importe esse módulo com o seguinte 
comando::

   >>> import fibo

Isso não coloca os nomes das funções definidas em ``fibo`` diretamente na tabela
de símbolos atual; isso coloca somente o nome do módulo ``fibo``. Usando o nome 
do módulo você pode acessar as funções.

   >>> fibo.fib(1000)
   1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987
   >>> fibo.fib2(100)
   [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
   >>> fibo.__name__
   'fibo'

Se você pretende usar uma função frequentemente, você pode associá-la a um nome
local::

   >>> fib = fibo.fib
   >>> fib(500)
   1 1 2 3 5 8 13 21 34 55 89 144 233 377


.. _tut-moremodules:

Mais sobre módulos
==================

Um módulo pode conter tanto comandos quanto definições de funções.
Esses comandos inicializam o módulo. E são executados somente na *primeira* vez 
que o módulo é importado em algum lugar. [#]_

Cada módulo tem sua própria tabela de símbolos, que é usada como a tabela de 
símbolos global para todas as funções definidas no módulo. Assim, o autor de um
módulo pode usar variáveis globais no seu módulo sem se preocupar com conflitos
acidentais com as variáveis globais do usuário. Por outro lado, se você precisar
usar uma varável global de um módulo, poderá fazê-lo com a mesma notação usadas
para se referenciar às funções, ``nome_do_modulo.nome_do_item``.

Módulos podem importar outros módulos. Isso é habitual mas não é necessário
colocar todos os comandos :keyword:`import` no início do módulo (ou script, 
onde for necessário). As definições do módulo importado são colocadas na tabela 
de símbolos global do módulo importador.

Existe uma variação do comando :keyword:`import` que importa definições de um 
módulo diretamente para a tabela de símbolos do módulo importador. Por exemplo::

   >>> from fibo import fib, fib2
   >>> fib(500)
   1 1 2 3 5 8 13 21 34 55 89 144 233 377

Isso não coloca o nome do módulo de onde foram feitas as importações para a 
tabela de símbolos local (assim, no exemplo ``fibo`` não está definido).

Existem também uma variante para importar todas as definições do módulo::

   >>> from fibo import *
   >>> fib(500)
   1 1 2 3 5 8 13 21 34 55 89 144 233 377

Isso importa todos as declarações, exceto aquelas que iniciam com um sublinhado
(``_``).

Perceba que, em geral, a prática do ``import *`` de um módulo ou pacote é
desaprovada, uma vez que frequentemente dificulta a leitura do código. Contudo,
isso é aceitável para diminuir a digitação em sessões interativas.

.. note::

   Por razões de eficiência, cada módulo é importado somente uma vez por sessão 
   do interpretador. Portanto, se você alterar seus módulos, você dever reiniciar
   o interpretador -- ou, se é somente um módulo que você quer testar 
   interativamente, use :func:`reload`, ex. ``reload(nome_do_modulo)``.


.. _tut-modulesasscripts:

Executando módulos como scripts
-------------------------------

Quando você executa um módulo Python com::

   python fibo.py <argumentos>

o código no módulo será executado, da mesma forma como você estivesse apenas 
importado, mas com o valor de ``__name__`` definido para ``"__main__"``. Isso
significa que adicionando este código no fim do seu módulo::

   if __name__ == "__main__":
       import sys
       fib(int(sys.argv[1]))

você permite que o arquivo seja usado tanto como um script quanto como um módulo 
que pode ser importado, porque o código que analisa a linha de comando somente
executa se o módulo é executado como o arquivo "principal"::

   $ python fibo.py 50
   1 1 2 3 5 8 13 21 34

Se o módulo é importado, o código não é executado::

   >>> import fibo
   >>>

Isso é frequentemente usado para fornece uma conveniente interface de usuário 
para um módulo, ou para propósitos de testes (executando o módulo como um script,
executa uma suíte de testes).


.. _tut-searchpath:

O caminho de busca por módulos
--------------------------------

.. index:: triple: module; search; path

Quando um módulo chamado :mod:`spam` é importado, o interpretador procura por um
arquivo chamado :file:`spam.py` no diretório que contém o script importador, 
depois na lista de diretórios especificada pela variável de ambiente
:envvar:`PYTHONPATH`. Ela tem a mesma sintaxe da variável de ambiente do shell
do sistema operacional :envvar:`PATH`, que é uma lista de nomes de diretórios.
Quando :envvar:`PYTHONPATH` não está definida, ou quando o arquivo não é 
encontrado nela, a procura continua em um caminho padrão dependente da 
instalação; em Unix, usualmente é :file:`.:/usr/local/lib/python`.

Na verdade, módulos são procurados na lista de diretórios dada pela variável
``sys.path`` que é inicializada com o diretório que contém o script importador
(ou o diretório atual), :envvar:`PYTHONPATH` e o padrão dependente da instalação.
Isso permite programas em Python saber o que está sendo feito para modificar ou
substituir o caminho de procura do módulo. Perceba que como o diretório contém o
script que iniciou a execução ele também está no caminho de procura, então é
importante que o script não tenha o mesmo nome de um módulo padrão, ou Python 
irá carregar o script como sendo o módulo, quando ele for importado. Isso 
geralmente será um erro. Veja seção :ref:`tut-standardmodules` para mais
informações.


Arquivos Python "compilados"
----------------------------

Um fator que agiliza a inicialização de programas curtos que usam muitos módulos padrões é a existência de um arquivo chamado :file:`spam.pyc` no diretório do 
fonte :file:`spam.py`. O arquivo :file:`spam.pyc` contém uma versão "byte-compilada" do fonte :file:`spam.py`. A hora de modificação de :file:`spam.py` é 
armazanda dentro do :file:`spam.pyc`, e verificada automaticamente antes da 
utilização do último. Se forem diferentes, o arquivo :file:`spam.pyc` existente 
é re-compilado a partir do :file:`spam.py` mais atual.

Normalmente, não é preciso fazer nada para gerar o arquivo :file:`spam.pyc`.
Sempre que :file:`spam.py` é compilado com sucesso, é feita uma tentativa para
escrever a versão compilada em :file:`spam.pyc`. Não há geração de um erro se 
essa tentativa falhar. Se por alguma razão o arquivo compilado não é inteiramente escrito em disco, o arquivo :file:`spam.pyc` resultante será reconhecido como inválido e, portanto, ignorado. O conteúdo do arquivo :file:`spam.pyc` é independente de plataforma, assim um diretório de módulos Python pode ser compartilhado por máquinas de diferentes arquiteturas.

Algumas dicas dos especialistas:

* Quando o interpretador Python é invocado com a diretiva :option:`-O`, é gerado 
  código otimizado e armazenado em arquivos :file:`.pyo`. O otimizador atual não
  faz muita coisa; ele apenas remove instruções :keyword:`assert`. Quando 
  :option:`-O` é utilizada, *todo* :term:`bytecode` é otimizado; arquivos 
  ``.pyc`` são ignorados e arquivo ``.py`` são compilados para bytecode otimizado.

* Passando duas diretivas :option:`-O` para o interpretador Python (:option:`-OO`) 
  fará com que o compilador realize otimizações arriscadas, que em alguns casos
  raros pode acarretar o mal funcionamento de programas. Atualmente apenas string
  ``__doc__`` são removidas do bytecode, resultando em arquivo :file:`.pyo` mais
  compactos. Uma vez que alguns programas podem supor a existência dessas 
  docstrings, somente use essa opção se você souber o que está fazendo e segurança
  de que não acarretará nenhum efeito colateral negativo.

* Um programa não executa mais rápido quando é lido de um arquivo :file:`.pyc` ou 
  :file:`.pyo` em comparação a quando é lido de um arquivo :file:`.py`. A única 
  diferença é que nos dois primeiros casos o tempo de inicialização do programa 
  é menor.

* Quando um script é executado diretamente a partir o seu nome da linha de
  comando, não são geradas as formas compiladas deste script em arquivo :file:`.pyc`
  ou :file:`.pyo`. Portanto, o tempo de carga de um script pode ser melhorado se 
  movermos a maioria de seu código para um módulo e utilizarmos outro script apenas
  para inicialização. Também é possível executar o interpretador diretamente sobre 
  arquivos compilados, passando seu nome na linha de comando.

* Na presença das formas compiladas (:file:`spam.pyc` e :file:`spam.pyo`) de um 
  script, não há necessidade da presença da forma textual (:file:`spam.py`). Isto 
  é útil na hora de se distribuir bibliotecas Python, dificultando práticas de 
  engenharia reversa.

  .. index:: module: compileall

* O módulo :mod:`compileall` pode criar arquivos :file:`.pyc` (ou :file:`.pyo` 
  quando é :option:`-O` é usada) para todos os módulos em um dado diretório.


.. _tut-standardmodules:

Standard Modules
================

.. index:: module: sys

Python comes with a library of standard modules, described in a separate
document, the Python Library Reference ("Library Reference" hereafter).  Some
modules are built into the interpreter; these provide access to operations that
are not part of the core of the language but are nevertheless built in, either
for efficiency or to provide access to operating system primitives such as
system calls.  The set of such modules is a configuration option which also
depends on the underlying platform For example, the :mod:`winreg` module is only
provided on Windows systems. One particular module deserves some attention:
:mod:`sys`, which is built into every Python interpreter.  The variables
``sys.ps1`` and ``sys.ps2`` define the strings used as primary and secondary
prompts::

   >>> import sys
   >>> sys.ps1
   '>>> '
   >>> sys.ps2
   '... '
   >>> sys.ps1 = 'C> '
   C> print 'Yuck!'
   Yuck!
   C>


These two variables are only defined if the interpreter is in interactive mode.

The variable ``sys.path`` is a list of strings that determines the interpreter's
search path for modules. It is initialized to a default path taken from the
environment variable :envvar:`PYTHONPATH`, or from a built-in default if
:envvar:`PYTHONPATH` is not set.  You can modify it using standard list
operations::

   >>> import sys
   >>> sys.path.append('/ufs/guido/lib/python')


.. _tut-dir:

The :func:`dir` Function
========================

The built-in function :func:`dir` is used to find out which names a module
defines.  It returns a sorted list of strings::

   >>> import fibo, sys
   >>> dir(fibo)
   ['__name__', 'fib', 'fib2']
   >>> dir(sys)
   ['__displayhook__', '__doc__', '__excepthook__', '__name__', '__stderr__',
    '__stdin__', '__stdout__', '_getframe', 'api_version', 'argv',
    'builtin_module_names', 'byteorder', 'callstats', 'copyright',
    'displayhook', 'exc_clear', 'exc_info', 'exc_type', 'excepthook',
    'exec_prefix', 'executable', 'exit', 'getdefaultencoding', 'getdlopenflags',
    'getrecursionlimit', 'getrefcount', 'hexversion', 'maxint', 'maxunicode',
    'meta_path', 'modules', 'path', 'path_hooks', 'path_importer_cache',
    'platform', 'prefix', 'ps1', 'ps2', 'setcheckinterval', 'setdlopenflags',
    'setprofile', 'setrecursionlimit', 'settrace', 'stderr', 'stdin', 'stdout',
    'version', 'version_info', 'warnoptions']

Without arguments, :func:`dir` lists the names you have defined currently::

   >>> a = [1, 2, 3, 4, 5]
   >>> import fibo
   >>> fib = fibo.fib
   >>> dir()
   ['__builtins__', '__doc__', '__file__', '__name__', 'a', 'fib', 'fibo', 'sys']

Note that it lists all types of names: variables, modules, functions, etc.

.. index:: module: __builtin__

:func:`dir` does not list the names of built-in functions and variables.  If you
want a list of those, they are defined in the standard module
:mod:`__builtin__`::

   >>> import __builtin__
   >>> dir(__builtin__)
   ['ArithmeticError', 'AssertionError', 'AttributeError', 'DeprecationWarning',
    'EOFError', 'Ellipsis', 'EnvironmentError', 'Exception', 'False',
    'FloatingPointError', 'FutureWarning', 'IOError', 'ImportError',
    'IndentationError', 'IndexError', 'KeyError', 'KeyboardInterrupt',
    'LookupError', 'MemoryError', 'NameError', 'None', 'NotImplemented',
    'NotImplementedError', 'OSError', 'OverflowError',
    'PendingDeprecationWarning', 'ReferenceError', 'RuntimeError',
    'RuntimeWarning', 'StandardError', 'StopIteration', 'SyntaxError',
    'SyntaxWarning', 'SystemError', 'SystemExit', 'TabError', 'True',
    'TypeError', 'UnboundLocalError', 'UnicodeDecodeError',
    'UnicodeEncodeError', 'UnicodeError', 'UnicodeTranslateError',
    'UserWarning', 'ValueError', 'Warning', 'WindowsError',
    'ZeroDivisionError', '_', '__debug__', '__doc__', '__import__',
    '__name__', 'abs', 'apply', 'basestring', 'bool', 'buffer',
    'callable', 'chr', 'classmethod', 'cmp', 'coerce', 'compile',
    'complex', 'copyright', 'credits', 'delattr', 'dict', 'dir', 'divmod',
    'enumerate', 'eval', 'execfile', 'exit', 'file', 'filter', 'float',
    'frozenset', 'getattr', 'globals', 'hasattr', 'hash', 'help', 'hex',
    'id', 'input', 'int', 'intern', 'isinstance', 'issubclass', 'iter',
    'len', 'license', 'list', 'locals', 'long', 'map', 'max', 'memoryview',
    'min', 'object', 'oct', 'open', 'ord', 'pow', 'property', 'quit', 'range',
    'raw_input', 'reduce', 'reload', 'repr', 'reversed', 'round', 'set',
    'setattr', 'slice', 'sorted', 'staticmethod', 'str', 'sum', 'super',
    'tuple', 'type', 'unichr', 'unicode', 'vars', 'xrange', 'zip']


.. _tut-packages:

Packages
========

Packages are a way of structuring Python's module namespace by using "dotted
module names".  For example, the module name :mod:`A.B` designates a submodule
named ``B`` in a package named ``A``.  Just like the use of modules saves the
authors of different modules from having to worry about each other's global
variable names, the use of dotted module names saves the authors of multi-module
packages like NumPy or the Python Imaging Library from having to worry about
each other's module names.

Suppose you want to design a collection of modules (a "package") for the uniform
handling of sound files and sound data.  There are many different sound file
formats (usually recognized by their extension, for example: :file:`.wav`,
:file:`.aiff`, :file:`.au`), so you may need to create and maintain a growing
collection of modules for the conversion between the various file formats.
There are also many different operations you might want to perform on sound data
(such as mixing, adding echo, applying an equalizer function, creating an
artificial stereo effect), so in addition you will be writing a never-ending
stream of modules to perform these operations.  Here's a possible structure for
your package (expressed in terms of a hierarchical filesystem)::

   sound/                          Top-level package
         __init__.py               Initialize the sound package
         formats/                  Subpackage for file format conversions
                 __init__.py
                 wavread.py
                 wavwrite.py
                 aiffread.py
                 aiffwrite.py
                 auread.py
                 auwrite.py
                 ...
         effects/                  Subpackage for sound effects
                 __init__.py
                 echo.py
                 surround.py
                 reverse.py
                 ...
         filters/                  Subpackage for filters
                 __init__.py
                 equalizer.py
                 vocoder.py
                 karaoke.py
                 ...

When importing the package, Python searches through the directories on
``sys.path`` looking for the package subdirectory.

The :file:`__init__.py` files are required to make Python treat the directories
as containing packages; this is done to prevent directories with a common name,
such as ``string``, from unintentionally hiding valid modules that occur later
on the module search path. In the simplest case, :file:`__init__.py` can just be
an empty file, but it can also execute initialization code for the package or
set the ``__all__`` variable, described later.

Users of the package can import individual modules from the package, for
example::

   import sound.effects.echo

This loads the submodule :mod:`sound.effects.echo`.  It must be referenced with
its full name. ::

   sound.effects.echo.echofilter(input, output, delay=0.7, atten=4)

An alternative way of importing the submodule is::

   from sound.effects import echo

This also loads the submodule :mod:`echo`, and makes it available without its
package prefix, so it can be used as follows::

   echo.echofilter(input, output, delay=0.7, atten=4)

Yet another variation is to import the desired function or variable directly::

   from sound.effects.echo import echofilter

Again, this loads the submodule :mod:`echo`, but this makes its function
:func:`echofilter` directly available::

   echofilter(input, output, delay=0.7, atten=4)

Note that when using ``from package import item``, the item can be either a
submodule (or subpackage) of the package, or some  other name defined in the
package, like a function, class or variable.  The ``import`` statement first
tests whether the item is defined in the package; if not, it assumes it is a
module and attempts to load it.  If it fails to find it, an :exc:`ImportError`
exception is raised.

Contrarily, when using syntax like ``import item.subitem.subsubitem``, each item
except for the last must be a package; the last item can be a module or a
package but can't be a class or function or variable defined in the previous
item.


.. _tut-pkg-import-star:

Importing \* From a Package
---------------------------

.. index:: single: __all__

Now what happens when the user writes ``from sound.effects import *``?  Ideally,
one would hope that this somehow goes out to the filesystem, finds which
submodules are present in the package, and imports them all.  This could take a
long time and importing sub-modules might have unwanted side-effects that should
only happen when the sub-module is explicitly imported.

The only solution is for the package author to provide an explicit index of the
package.  The :keyword:`import` statement uses the following convention: if a package's
:file:`__init__.py` code defines a list named ``__all__``, it is taken to be the
list of module names that should be imported when ``from package import *`` is
encountered.  It is up to the package author to keep this list up-to-date when a
new version of the package is released.  Package authors may also decide not to
support it, if they don't see a use for importing \* from their package.  For
example, the file :file:`sounds/effects/__init__.py` could contain the following
code::

   __all__ = ["echo", "surround", "reverse"]

This would mean that ``from sound.effects import *`` would import the three
named submodules of the :mod:`sound` package.

If ``__all__`` is not defined, the statement ``from sound.effects import *``
does *not* import all submodules from the package :mod:`sound.effects` into the
current namespace; it only ensures that the package :mod:`sound.effects` has
been imported (possibly running any initialization code in :file:`__init__.py`)
and then imports whatever names are defined in the package.  This includes any
names defined (and submodules explicitly loaded) by :file:`__init__.py`.  It
also includes any submodules of the package that were explicitly loaded by
previous :keyword:`import` statements.  Consider this code::

   import sound.effects.echo
   import sound.effects.surround
   from sound.effects import *

In this example, the :mod:`echo` and :mod:`surround` modules are imported in the
current namespace because they are defined in the :mod:`sound.effects` package
when the ``from...import`` statement is executed.  (This also works when
``__all__`` is defined.)

Although certain modules are designed to export only names that follow certain
patterns when you use ``import *``, it is still considered bad practise in
production code.

Remember, there is nothing wrong with using ``from Package import
specific_submodule``!  In fact, this is the recommended notation unless the
importing module needs to use submodules with the same name from different
packages.


Intra-package References
------------------------

The submodules often need to refer to each other.  For example, the
:mod:`surround` module might use the :mod:`echo` module.  In fact, such
references are so common that the :keyword:`import` statement first looks in the
containing package before looking in the standard module search path. Thus, the
:mod:`surround` module can simply use ``import echo`` or ``from echo import
echofilter``.  If the imported module is not found in the current package (the
package of which the current module is a submodule), the :keyword:`import`
statement looks for a top-level module with the given name.

When packages are structured into subpackages (as with the :mod:`sound` package
in the example), you can use absolute imports to refer to submodules of siblings
packages.  For example, if the module :mod:`sound.filters.vocoder` needs to use
the :mod:`echo` module in the :mod:`sound.effects` package, it can use ``from
sound.effects import echo``.

Starting with Python 2.5, in addition to the implicit relative imports described
above, you can write explicit relative imports with the ``from module import
name`` form of import statement. These explicit relative imports use leading
dots to indicate the current and parent packages involved in the relative
import. From the :mod:`surround` module for example, you might use::

   from . import echo
   from .. import formats
   from ..filters import equalizer

Note that both explicit and implicit relative imports are based on the name of
the current module. Since the name of the main module is always ``"__main__"``,
modules intended for use as the main module of a Python application should
always use absolute imports.


Packages in Multiple Directories
--------------------------------

Packages support one more special attribute, :attr:`__path__`.  This is
initialized to be a list containing the name of the directory holding the
package's :file:`__init__.py` before the code in that file is executed.  This
variable can be modified; doing so affects future searches for modules and
subpackages contained in the package.

While this feature is not often needed, it can be used to extend the set of
modules found in a package.


.. rubric:: Footnotes

.. [#] In fact function definitions are also 'statements' that are 'executed'; the
   execution of a module-level function enters the function name in the module's
   global symbol table.

