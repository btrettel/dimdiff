! # $File$
! 
! Summary: tests for testmod
! Standard: Fortran 90, ELF90 subset
! Preprocessor: none
! Author: Ben Trettel (<http://trettel.us/>)
! Last updated: $Date$
! Revision: $Revision$
! Project: [flt](https://github.com/btrettel/flt)
! License: [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

program test_testmod

use asserts, only: is_close
use logging, only: start_log
use prec, only: I5, RP
use testmod, only: test_type, logical_test, real_equality_test, real_inequality_test, integer_equality_test, &
                    string_equality_test, start_tests, end_tests
implicit none

type(test_type)  :: test_data, test_data_2

character(len=*), parameter :: LOG_FILENAME = "testmod.jsonl"

call start_tests(LOG_FILENAME, test_data)
call start_tests(LOG_FILENAME, test_data_2) ! These are for tests which should fail.
call start_log(LOG_FILENAME)

call integer_equality_test(test_data%number_of_failures, 0_I5, "test_data%number_of_failures at start", test_data)
call integer_equality_test(test_data%number_of_tests, 1_I5, "test_data%number_of_tests at start", test_data)

call integer_equality_test(test_data_2%number_of_failures, 0_I5, "test_data_2%number_of_failures at start", test_data)
call integer_equality_test(test_data_2%number_of_tests, 0_I5, "test_data_2%number_of_tests at start", test_data)

call logical_test(.true., "logical_test, .true.", test_data)

call logical_test(is_close(1.0_RP, 1.0_RP), "is_close, identical numbers (1)", test_data)

call logical_test(is_close(15.0_RP, 15.0_RP), "is_close, identical numbers (2)", test_data)

call logical_test(is_close(0.0001_RP, 0.0001_RP), "is_close, identical numbers (3)", test_data)

call logical_test(.not. is_close(1.0_RP, 10.0_RP), "is_close, different numbers (1)", test_data)

call logical_test(.not. is_close(5.0_RP, 1000.0_RP), "is_close, different numbers (2)", test_data)

call logical_test(.not. is_close(0.1_RP, 1000.0_RP), "is_close, different numbers (3)", test_data)

call logical_test(is_close(1.0_RP, 1.0_RP + 5.0_RP * epsilon(1.0_RP)), &
    "is_close, different numbers within tolerance (1)", test_data)

call logical_test(is_close(100.0_RP, 100.0_RP + 5.0_RP * epsilon(1.0_RP)), &
    "is_close, different numbers within tolerance (2)", test_data)

call logical_test(is_close(0.1_RP, 0.1_RP + 5.0_RP * epsilon(1.0_RP)), &
    "is_close, different numbers within tolerance (3)", test_data)

call logical_test(.not. is_close(1.0_RP, 1.0_RP + 20.0_RP * epsilon(1.0_RP)), &
    "is_close, barely different numbers (1)", test_data)

call logical_test(.not. is_close(100.0_RP, 100.0_RP + 1000.0_RP * epsilon(1.0_RP)), &
    "is_close, barely different numbers (2)", test_data)

call logical_test(.not. is_close(0.1_RP, 0.1_RP + 11.0_RP * epsilon(1.0_RP)), &
    "is_close, barely different numbers (3)", test_data)

call logical_test(is_close(0.0_RP, 0.0_RP), "is_close, both zero", test_data)

call logical_test(.not. is_close(0.0_RP, 100.0_RP * epsilon(1.0_RP)), &
    "is_close, one zero, one different (1)", test_data)

call logical_test(.not. is_close(100.0_RP * epsilon(1.0_RP), 0.0_RP), &
    "is_close, one zero, one different (2)", test_data)

call logical_test(is_close(1.0_RP, 1.05_RP, abs_tol=0.1_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, inside abs_tol (1)", test_data)

call logical_test(is_close(10.0_RP, 10.1_RP, abs_tol=0.2_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, inside abs_tol (2)", test_data)

call logical_test(is_close(0.1_RP, 0.11_RP, abs_tol=0.02_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, inside abs_tol (3)", test_data)

call logical_test(.not. is_close(1.0_RP, 1.15_RP, abs_tol=0.1_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, outside abs_tol (1)", test_data)

call logical_test(.not. is_close(20.0_RP, 21.0_RP, abs_tol=0.5_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, outside abs_tol (2)", test_data)

call logical_test(.not. is_close(0.01_RP, 0.02_RP, abs_tol=0.005_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, outside abs_tol (3)", test_data)

call logical_test(is_close(1.0_RP, 1.05_RP, abs_tol=0.0_RP, rel_tol=0.1_RP), &
        "is_close, close numbers with set rel_tol, inside rel_tol", test_data)

call logical_test(.not. is_close(1.0_RP, 1.15_RP, abs_tol=0.0_RP, rel_tol=0.1_RP), &
        "is_close, close numbers with set rel_tol, outside rel_tol (1)", test_data)

call logical_test(.not. is_close(20.0_RP, 19.7_RP, abs_tol=0.0_RP, rel_tol=0.01_RP), &
        "is_close, close numbers with set rel_tol, outside rel_tol (2)", test_data)

call logical_test(.not. is_close(0.0001_RP, 0.0003_RP, abs_tol=0.0_RP, rel_tol=0.1_RP), &
        "is_close, close numbers with set rel_tol, outside rel_tol (3)", test_data)

call logical_test(.not. is_close(1.0_RP, 0.0_RP, abs_tol=1.0_RP, rel_tol=0.0_RP), &
        "is_close, close numbers with set abs_tol, just outside", test_data)

call logical_test(.not. is_close(1.0_RP, 0.0_RP, abs_tol=0.0_RP, rel_tol=1.0_RP), &
        "is_close, close numbers with set rel_tol, just outside", test_data)

call real_equality_test(1.0_RP, 1.0_RP, "real_equality_test, identical numbers (1)", test_data)

call real_equality_test(15.0_RP, 15.0_RP, "real_equality_test, identical numbers (2)", test_data)

call real_equality_test(0.0001_RP, 0.0001_RP, "real_equality_test, identical numbers (3)", test_data)

call real_inequality_test(1.0_RP, 10.0_RP, "real_inequality_test, different numbers (1)", test_data)

call real_inequality_test(5.0_RP, 1000.0_RP, "real_inequality_test, different numbers (2)", test_data)

call real_inequality_test(0.1_RP, 1000.0_RP, "real_inequality_test, different numbers (3)", test_data)

call real_equality_test(1.0_RP, 1.0_RP + 5.0_RP * epsilon(1.0_RP), &
    "real_equality_test, different numbers within tolerance (1)", test_data)

call real_equality_test(100.0_RP, 100.0_RP + 5.0_RP * epsilon(1.0_RP), &
    "real_equality_test, different numbers within tolerance (2)", test_data)

call real_equality_test(0.1_RP, 0.1_RP + 5.0_RP * epsilon(1.0_RP), &
    "real_equality_test, different numbers within tolerance (3)", test_data)

call real_inequality_test(1.0_RP, 1.0_RP + 20.0_RP * epsilon(1.0_RP), &
    "real_inequality_test, barely different numbers (1)", test_data)

call real_inequality_test(100.0_RP, 100.0_RP + 1000.0_RP * epsilon(1.0_RP), &
    "real_inequality_test, barely different numbers (2)", test_data)

call real_inequality_test(0.1_RP, 0.1_RP + 11.0_RP * epsilon(1.0_RP), &
    "real_inequality_test, barely different numbers (3)", test_data)

call real_equality_test(0.0_RP, 0.0_RP, "real_equality_test, both zero", test_data)

call real_inequality_test(0.0_RP, 100.0_RP * epsilon(1.0_RP), &
    "real_inequality_test, one zero, one different (1)", test_data)

call real_inequality_test(100.0_RP * epsilon(1.0_RP), 0.0_RP, &
    "real_inequality_test, one zero, one different (2)", test_data)

call integer_equality_test(1_I5, 1_I5, "integer_equality_test", test_data)

call string_equality_test("a", "a", "string_equality_test", test_data)

call real_equality_test(10.0_RP, 5.0_RP, "real_equality_test, large abs_tol set", test_data, abs_tol=5.1_RP)

! tests which should fail

call logical_test(.false., "logical_test, failure", test_data_2)

call real_equality_test(1.0_RP, 0.0_RP, "real_equality_test, failure (greater)", test_data_2)

call real_equality_test(0.0_RP, 1.0_RP, "real_equality_test, failure (less)", test_data_2)

call real_inequality_test(1.0_RP, 1.0_RP, "real_inequality_test, failure", test_data_2)

call real_equality_test(10.0_RP, 5.0_RP, "real_equality_test, failure, abs_tol set", test_data_2, abs_tol=4.1_RP)

call integer_equality_test(1_I5, 0_I5, "integer_equality_test, failure (greater)", test_data_2)

call integer_equality_test(0_I5, 1_I5, "integer_equality_test, failure (less)", test_data_2)

call string_equality_test("a", "b", "string_equality_test, failure (greater)", test_data_2)

call string_equality_test("b", "a", "string_equality_test, failure (less)", test_data_2)

! Now check that the expected number of tests that should fail did in fact fail, and update the total number of tests appropriately.

call integer_equality_test(test_data_2%number_of_tests, 9_I5, "correct number of tests expected to fail", test_data)
call integer_equality_test(test_data_2%number_of_failures, 9_I5, "correct number of tests expected to fail that fail", test_data)

test_data%number_of_tests    = test_data%number_of_tests + test_data_2%number_of_tests
test_data%number_of_failures = test_data%number_of_failures + (test_data_2%number_of_tests - test_data_2%number_of_failures)

call end_tests(test_data)

stop

end program test_testmod
