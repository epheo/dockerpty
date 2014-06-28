# dockerpty.
#
# Copyright 2014 Chris Corbyn <chris@w3style.co.uk>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Feature: Using a pseudo-terminal
  As a user I want to be able to attach to a shell in a running docker
  container and control it as if it is running on my own computer.


  Scenario: Starting the PTY
    Given I am using a TTY
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    Then I will see the output
      """
      / #
      """


  Scenario: Controlling input
    Given I am using a TTY
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I type "whoami"
    Then I will see the output
      """
      / # whoami
      """


  Scenario: Controlling standard output
    Given I am using a TTY
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I type "uname"
    And I press ENTER
    Then I will see the output
      """
      / # uname
      Linux
      / #
      """


  Scenario: Controlling standard error
    Given I am using a TTY
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I type "ls blah"
    And I press ENTER
    Then I will see the output
      """
      / # ls blah
      ls: blah: No such file or directory
      / #
      """


  Scenario: Initializing the PTY with the correct size
    Given I am using a TTY with dimensions 20 x 70
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I type "stty size"
    And I press ENTER
    Then I will see the output
      """
      / # stty size
      20 70
      / #
      """


  Scenario: Resizing the PTY
    Given I am using a TTY with dimensions 20 x 70
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I resize the terminal to 30 x 100
    And I type "stty size"
    And I press ENTER
    Then I will see the output
      """
      / # stty size
      30 100
      / #
      """


  Scenario: Terminating the PTY
    Given I am using a TTY
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I type "exit"
    And I press ENTER
    Then The PTY will be closed cleanly
    And The container will not be running


  Scenario: Detaching from the PTY
    Given I am using a TTY
    And I start /bin/sh in a docker container with a PTY
    When I start dockerpty
    And I type "ls"
    And I press ENTER
    And I press C-p
    And I press C-q
    Then The PTY will be closed cleanly
    And The container will still be running
