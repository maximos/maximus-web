#!/usr/bin/env perl

use local::lib;
use Catalyst::ScriptRunner;
Catalyst::ScriptRunner->run('Maximus', 'Task');

=head1 NAME

maximus_task.pl - Execute a Maximus task

=head1 SYNOPSIS

maximus_task.pl [options]

   -t --task           Task to execute, e.g. Modules::Update
   -q --queue          Send task (and sub-tasks) to the queue server
   --dump_response     Dump response to STDOUT

=head1 DESCRIPTION

Run a Maximus task from the command line.

=head1 SEE ALSO

L<maximus_worker>

=head1 AUTHORS

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2013 Christiaan Kras

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut

1;
