.. _tut-brieftour:

***************************************
Um breve passeio pela biblioteca padrão
***************************************


.. _tut-os-interface:

Interface com o sistema operacional
===================================

O módulo :mod:`os` fornece dúzias de funções para interagir com o sistema operacional::

   >>> import os
   >>> os.getcwd()      # Retorna o diretório de trabalho atual
   'C:\\Python26'
   >>> os.chdir('/server/accesslogs')   # Altera o diretório de trabalho atual
   >>> os.system('mkdir today')   # Executa o comando mkdir no shell do sistema
   0

Tome cuidado para usar a forma ``import os`` ao invés de ``from os import *``.
Isso evitará que :func:`os.open` oculte a função :func:`open` que opera de forma
muito diferente.

.. index:: builtin: help

As funções embutidas :func:`dir` e :func:`help` são uteis como um sistema de ajuda
interativa pra lidar com módulos grandes como :mod:`os`::

   >>> import os
   >>> dir(os)
   <retorna uma lista com todas as funções do módulo>
   >>> help(os)
   <retorna uma extensa página de manual criada a partir das docstrings do módulo>

Para tarefas de gerenciamento diário de arquivos e diretórios, o módulo :mod:`shutil` fornece
uma interface de alto nível que é mais simples de usar::

   >>> import shutil
   >>> shutil.copyfile('data.db', 'archive.db')
   >>> shutil.move('/build/executables', 'installdir')


.. _tut-file-wildcards:

Caracteres coringa
==================

O módulo :mod:`glob` fornece uma função para criar listas de arquivos a partir
de buscas em diretórios usando caracteres coringa::

   >>> import glob
   >>> glob.glob('*.py')
   ['primes.py', 'random.py', 'quote.py']


.. _tut-command-line-arguments:

Argumentos de linha de comando
==============================

Scripts geralmente precisam processar argumentos passados na linha de comando.
Esses argumentos são armazenados como uma lista no atributo *argv* do módulo
:mod:`sys`. Por exemplo, teríamos a seguinte saída executando ``python demo.py 
one two three`` na linha de comando::

   >>> import sys
   >>> print sys.argv
   ['demo.py', 'one', 'two', 'three']

O módulo :mod:`getopt` processa os argumentos passados em sys.argv usando as
convenções da função Unix :mod:`getopt`. Um processamento mais poderoso e
flexível é fornecido pelo módulo :mod:`argparse`.


.. _tut-stderr:

Redirecionamento de error e encerramento do programa
====================================================

O módulo :mod:`sys` também possui atributos para *stdin*, *stdout* e *stderr*.
O último é usado para emitir avisos e mensagens de erros visíveis mesmo quando
*stdout* foi redirecionado::

   >>> sys.stderr.write('Warning, log file not found starting a new one\n')
   Warning, log file not found starting a new one

A forma mais direta de encerrar um script é usando ``sys.exit()``.


.. _tut-string-pattern-matching:

Reconhecimento de padrões em strings
====================================

O módulo :mod:`re` fornece ferramentas para lidar com processamento de strings
através de expressões regulares. Para reconhecimento de padrões complexos,
expressões regulares  oferecem uma solução sucinta e eficiente::

   >>> import re
   >>> re.findall(r'\bf[a-z]*', 'which foot or hand fell fastest')
   ['foot', 'fell', 'fastest']
   >>> re.sub(r'(\b[a-z]+) \1', r'\1', 'cat in the the hat')
   'cat in the hat'

Quando as exigências são simples, métodos de strings são preferíveis por serem
mais fáceis de ler e depurar::

   >>> 'tea for too'.replace('too', 'two')
   'tea for two'


.. _tut-mathematics:

Matemática
==========

O módulo :mod:`math` oferece acesso as funções da biblioteca C para matemática
e ponto flutuante::

   >>> import math
   >>> math.cos(math.pi / 4.0)
   0.70710678118654757
   >>> math.log(1024, 2)
   10.0

O módulo :mod:`random` fornece ferramentas para gerar seleções aleatórias::

   >>> import random
   >>> random.choice(['apple', 'pear', 'banana'])
   'apple'
   >>> random.sample(xrange(100), 10)   # sampling without replacement
   [30, 83, 16, 4, 8, 81, 41, 50, 18, 33]
   >>> random.random()    # float aleatório
   0.17970987693706186
   >>> random.randrange(6)    # inteiro aleatório escolhido de range(6)
   4


.. _tut-internet-access:

Acesso a internet
=================

Há diversos módulos para acesso e processamento de protocolos da internet. Dois dos
mais simples são :mod:`urllib2` para efetuar download de dados a partir de urls e
:mod:`smtplib` para enviar mensagens de correio eletrônico::

   >>> import urllib2
   >>> for line in urllib2.urlopen('http://tycho.usno.navy.mil/cgi-bin/timer.pl'):
   ...     if 'EST' in line or 'EDT' in line:  # procurar pela hora do leste
   ...         print line

   <BR>Nov. 25, 09:43:32 PM EST

   >>> import smtplib
   >>> server = smtplib.SMTP('localhost')
   >>> server.sendmail('soothsayer@example.org', 'jcaesar@example.org',
   ... """To: jcaesar@example.org
   ... From: soothsayer@example.org
   ...
   ... Beware the Ides of March.
   ... """)
   >>> server.quit()

(Note que o segundo exemplo precisa de um servidor de email rodando em localhost.)


.. _tut-dates-and-times:

Data e Hora
===========

O módulo :mod:`datetime` fornece classes para manipulação de datas e horas nas
mais variadas formas. Apesar da disponibilidade de aritmética com data e hora,
o foco da implementação é na extração eficiente dos membros para formatação e
manipulação. O módulo também oferece objetos que levam os fusos horários em
consideração::

   >>> # dates are easily constructed and formatted
   >>> from datetime import date
   >>> now = date.today()
   >>> now
   datetime.date(2003, 12, 2)
   >>> now.strftime("%m-%d-%y. %d %b %Y is a %A on the %d day of %B.")
   '12-02-03. 02 Dec 2003 is a Tuesday on the 02 day of December.'

   >>> # dates support calendar arithmetic
   >>> birthday = date(1964, 7, 31)
   >>> age = now - birthday
   >>> age.days
   14368


.. _tut-data-compression:

Data Compression
================

Common data archiving and compression formats are directly supported by modules
including: :mod:`zlib`, :mod:`gzip`, :mod:`bz2`, :mod:`zipfile` and
:mod:`tarfile`. ::

   >>> import zlib
   >>> s = 'witch which has which witches wrist watch'
   >>> len(s)
   41
   >>> t = zlib.compress(s)
   >>> len(t)
   37
   >>> zlib.decompress(t)
   'witch which has which witches wrist watch'
   >>> zlib.crc32(s)
   226805979


.. _tut-performance-measurement:

Performance Measurement
=======================

Some Python users develop a deep interest in knowing the relative performance of
different approaches to the same problem. Python provides a measurement tool
that answers those questions immediately.

For example, it may be tempting to use the tuple packing and unpacking feature
instead of the traditional approach to swapping arguments. The :mod:`timeit`
module quickly demonstrates a modest performance advantage::

   >>> from timeit import Timer
   >>> Timer('t=a; a=b; b=t', 'a=1; b=2').timeit()
   0.57535828626024577
   >>> Timer('a,b = b,a', 'a=1; b=2').timeit()
   0.54962537085770791

In contrast to :mod:`timeit`'s fine level of granularity, the :mod:`profile` and
:mod:`pstats` modules provide tools for identifying time critical sections in
larger blocks of code.


.. _tut-quality-control:

Quality Control
===============

One approach for developing high quality software is to write tests for each
function as it is developed and to run those tests frequently during the
development process.

The :mod:`doctest` module provides a tool for scanning a module and validating
tests embedded in a program's docstrings.  Test construction is as simple as
cutting-and-pasting a typical call along with its results into the docstring.
This improves the documentation by providing the user with an example and it
allows the doctest module to make sure the code remains true to the
documentation::

   def average(values):
       """Computes the arithmetic mean of a list of numbers.

       >>> print average([20, 30, 70])
       40.0
       """
       return sum(values, 0.0) / len(values)

   import doctest
   doctest.testmod()   # automatically validate the embedded tests

The :mod:`unittest` module is not as effortless as the :mod:`doctest` module,
but it allows a more comprehensive set of tests to be maintained in a separate
file::

   import unittest

   class TestStatisticalFunctions(unittest.TestCase):

       def test_average(self):
           self.assertEqual(average([20, 30, 70]), 40.0)
           self.assertEqual(round(average([1, 5, 7]), 1), 4.3)
           self.assertRaises(ZeroDivisionError, average, [])
           self.assertRaises(TypeError, average, 20, 30, 70)

   unittest.main() # Calling from the command line invokes all tests


.. _tut-batteries-included:

Batteries Included
==================

Python has a "batteries included" philosophy.  This is best seen through the
sophisticated and robust capabilities of its larger packages. For example:

* The :mod:`xmlrpclib` and :mod:`SimpleXMLRPCServer` modules make implementing
  remote procedure calls into an almost trivial task.  Despite the modules
  names, no direct knowledge or handling of XML is needed.

* The :mod:`email` package is a library for managing email messages, including
  MIME and other RFC 2822-based message documents. Unlike :mod:`smtplib` and
  :mod:`poplib` which actually send and receive messages, the email package has
  a complete toolset for building or decoding complex message structures
  (including attachments) and for implementing internet encoding and header
  protocols.

* The :mod:`xml.dom` and :mod:`xml.sax` packages provide robust support for
  parsing this popular data interchange format. Likewise, the :mod:`csv` module
  supports direct reads and writes in a common database format. Together, these
  modules and packages greatly simplify data interchange between Python
  applications and other tools.

* Internationalization is supported by a number of modules including
  :mod:`gettext`, :mod:`locale`, and the :mod:`codecs` package.


