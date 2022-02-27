# Example using a template with data from different sources.

This example creates 3 files from a j2 template file that uses variables
from two different sources.  The playbook, `make_file.yml`, demonstrates how
to `register` shell output within a `loop`.  The playbook also demonstrates the use
of the `zip()` function in a loop.

```
redcricket@Reds-MacBook-Pro Register_var_with_loop % ls -l
total 72
-rw-r--r--  1 redcricket  staff    290 Feb 26 19:37 README.md
-rw-r--r--  1 redcricket  staff     34 Feb 25 21:46 datafile.txt
-rw-r--r--  1 redcricket  staff    912 Feb 26 19:21 make_file.yml
-rw-r--r--  1 redcricket  staff     50 Feb 26 19:21 template-file.j2
redcricket@Reds-MacBook-Pro Register_var_with_loop % cat datafile.txt
1 one a
2 two b
3 three c
4 our d
redcricket@Reds-MacBook-Pro Register_var_with_loop % cat template-file.j2
Z1 = {{ item.0.stdout }}
Z2 = {{ item.1.stdout }}
redcricket@Reds-MacBook-Pro Register_var_with_loop % cat make_file.yml
---
- name: Make files
  hosts: localhost
  gather_facts: False
  vars:
    start: 1
    end: 4

  tasks:
  - name: Set word
    shell: |
      grep {{ item }} datafile.txt | cut -d ' ' -f2
    register: word_var
    loop: "{{ range(start, end) | list }}"

  - name: Set letter
    shell: |
      grep {{ item }} datafile.txt | cut -d ' ' -f3
    register: letter_var
    loop: "{{ range(start, end) | list }}"

  - name: create files
    template:
      src: template-file.j2
      dest: "{{ item.0.stdout }}_file.txt"
    loop: "{{ word_var.results|zip(letter_var.results)|list }}"


redcricket@Reds-MacBook-Pro Register_var_with_loop % ansible-playbook -i,localhost make_file.yml --connection=local

PLAY [Make files] *****************************************************************************************************************************************************************************************

TASK [Set word] *******************************************************************************************************************************************************************************************
changed: [localhost] => (item=1)
changed: [localhost] => (item=2)
changed: [localhost] => (item=3)
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /usr/bin/python, but future installation of another Python interpreter could change the meaning of that path.
See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information.

TASK [Set letter] *****************************************************************************************************************************************************************************************
changed: [localhost] => (item=1)
changed: [localhost] => (item=2)
changed: [localhost] => (item=3)

TASK [create files] ***************************************************************************************************************************************************************************************
changed: [localhost] => (item=[{'changed': True, 'end': '2022-02-26 19:43:30.747027', 'stdout': 'one', 'cmd': "grep 1 datafile.txt | cut -d ' ' -f2\n", 'rc': 0, 'start': '2022-02-26 19:43:30.740330', 'stderr': '', 'delta': '0:00:00.006697', 'invocation': {'module_args': {'creates': None, 'executable': None, '_uses_shell': True, 'strip_empty_ends': True, '_raw_params': "grep 1 datafile.txt | cut -d ' ' -f2\n", 'removes': None, 'argv': None, 'warn': True, 'chdir': None, 'stdin_add_newline': True, 'stdin': None}}, 'stdout_lines': ['one'], 'stderr_lines': [], 'ansible_facts': {'discovered_interpreter_python': '/usr/bin/python'}, 'failed': False, 'item': 1, 'ansible_loop_var': 'item'}, {'changed': True, 'end': '2022-02-26 19:43:31.434951', 'stdout': 'a', 'cmd': "grep 1 datafile.txt | cut -d ' ' -f3\n", 'rc': 0, 'start': '2022-02-26 19:43:31.426668', 'stderr': '', 'delta': '0:00:00.008283', 'invocation': {'module_args': {'creates': None, 'executable': None, '_uses_shell': True, 'strip_empty_ends': True, '_raw_params': "grep 1 datafile.txt | cut -d ' ' -f3\n", 'removes': None, 'argv': None, 'warn': True, 'chdir': None, 'stdin_add_newline': True, 'stdin': None}}, 'stdout_lines': ['a'], 'stderr_lines': [], 'failed': False, 'item': 1, 'ansible_loop_var': 'item'}])
changed: [localhost] => (item=[{'changed': True, 'end': '2022-02-26 19:43:30.967349', 'stdout': 'two', 'cmd': "grep 2 datafile.txt | cut -d ' ' -f2\n", 'rc': 0, 'start': '2022-02-26 19:43:30.960710', 'stderr': '', 'delta': '0:00:00.006639', 'invocation': {'module_args': {'creates': None, 'executable': None, '_uses_shell': True, 'strip_empty_ends': True, '_raw_params': "grep 2 datafile.txt | cut -d ' ' -f2\n", 'removes': None, 'argv': None, 'warn': True, 'chdir': None, 'stdin_add_newline': True, 'stdin': None}}, 'stdout_lines': ['two'], 'stderr_lines': [], 'failed': False, 'item': 2, 'ansible_loop_var': 'item'}, {'changed': True, 'end': '2022-02-26 19:43:31.652783', 'stdout': 'b', 'cmd': "grep 2 datafile.txt | cut -d ' ' -f3\n", 'rc': 0, 'start': '2022-02-26 19:43:31.645399', 'stderr': '', 'delta': '0:00:00.007384', 'invocation': {'module_args': {'creates': None, 'executable': None, '_uses_shell': True, 'strip_empty_ends': True, '_raw_params': "grep 2 datafile.txt | cut -d ' ' -f3\n", 'removes': None, 'argv': None, 'warn': True, 'chdir': None, 'stdin_add_newline': True, 'stdin': None}}, 'stdout_lines': ['b'], 'stderr_lines': [], 'failed': False, 'item': 2, 'ansible_loop_var': 'item'}])
changed: [localhost] => (item=[{'changed': True, 'end': '2022-02-26 19:43:31.188856', 'stdout': 'three', 'cmd': "grep 3 datafile.txt | cut -d ' ' -f2\n", 'rc': 0, 'start': '2022-02-26 19:43:31.181297', 'stderr': '', 'delta': '0:00:00.007559', 'invocation': {'module_args': {'creates': None, 'executable': None, '_uses_shell': True, 'strip_empty_ends': True, '_raw_params': "grep 3 datafile.txt | cut -d ' ' -f2\n", 'removes': None, 'argv': None, 'warn': True, 'chdir': None, 'stdin_add_newline': True, 'stdin': None}}, 'stdout_lines': ['three'], 'stderr_lines': [], 'failed': False, 'item': 3, 'ansible_loop_var': 'item'}, {'changed': True, 'end': '2022-02-26 19:43:31.866474', 'stdout': 'c', 'cmd': "grep 3 datafile.txt | cut -d ' ' -f3\n", 'rc': 0, 'start': '2022-02-26 19:43:31.859995', 'stderr': '', 'delta': '0:00:00.006479', 'invocation': {'module_args': {'creates': None, 'executable': None, '_uses_shell': True, 'strip_empty_ends': True, '_raw_params': "grep 3 datafile.txt | cut -d ' ' -f3\n", 'removes': None, 'argv': None, 'warn': True, 'chdir': None, 'stdin_add_newline': True, 'stdin': None}}, 'stdout_lines': ['c'], 'stderr_lines': [], 'failed': False, 'item': 3, 'ansible_loop_var': 'item'}])

PLAY RECAP ************************************************************************************************************************************************************************************************
localhost                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

redcricket@Reds-MacBook-Pro Register_var_with_loop % ls -l
total 120
-rw-r--r--  1 redcricket  staff    290 Feb 26 19:37 README.md
-rw-r--r--  1 redcricket  staff     34 Feb 25 21:46 datafile.txt
-rw-r--r--  1 redcricket  staff    912 Feb 26 19:21 make_file.yml
-rw-r--r--  1 redcricket  staff     16 Feb 26 19:43 one_file.txt
-rw-r--r--  1 redcricket  staff     50 Feb 26 19:21 template-file.j2
-rw-r--r--  1 redcricket  staff     18 Feb 26 19:43 three_file.txt
-rw-r--r--  1 redcricket  staff     16 Feb 26 19:43 two_file.txt
redcricket@Reds-MacBook-Pro Register_var_with_loop % cat one_file.txt
Z1 = one
Z2 = a
redcricket@Reds-MacBook-Pro Register_var_with_loop % cat two_file.txt
Z1 = two
Z2 = b
redcricket@Reds-MacBook-Pro Register_var_with_loop % cat three_file.txt
Z1 = three
Z2 = c
```

Also See:
https://www.redhat.com/sysadmin/linux-script-command

```
script --t=script_log -q scriptfile
```
