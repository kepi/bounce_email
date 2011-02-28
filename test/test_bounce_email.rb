require File.dirname(__FILE__) + '/test_helper.rb'

class TestBounceEmail < Test::Unit::TestCase

  def test_bounce_type_hard_fail
    bounce = test_bounce('tt_bounce_01')
    assert_equal '5.1.2', bounce.code, "Code should return 5.1.2, returns #{bounce.code}"
    assert_equal BounceEmail::TYPE_HARD_FAIL, bounce.type
  end

  def test_bounce_type_soft_fail
    bounce = test_bounce('tt_bounce_10')
    assert_equal '4.0.0', bounce.code, "Code should return 4.0.0, returns #{bounce.code}"
    assert_equal BounceEmail::TYPE_SOFT_FAIL, bounce.type
  end

  #  Specific tests
  def test_unrouteable_mail_domain
    bounce = test_bounce('tt_bounce_01')
    assert_equal '5.1.2', bounce.code, "Code should return 5.1.2, returns #{bounce.code}"

    bounce = test_bounce('tt_bounce_02')
    assert_equal '5.1.2', bounce.code, "Code should return 5.1.2, returns #{bounce.code}"
  end

  def test_set_5_0_status
    bounce = test_bounce('tt_bounce_03')
    assert_equal '5.0.0', bounce.code, "Code should return 5.0.0, returns #{bounce.code}"

    bounce = test_bounce('tt_bounce_04')
    assert_equal '5.0.0', bounce.code, "Code should return 5.0.0, returns #{bounce.code}"

    bounce = test_bounce('tt_bounce_05')
    assert_equal '5.0.0', bounce.code, "Code should return 5.0.0, returns #{bounce.code}"
  end

  def test_rota_dnsbl # TODO make this more general (match DNSBL only?)
    bounce = test_bounce('tt_bounce_06')
    assert_equal '5.7.1', bounce.code, "Code should return 5.7.1, returns #{bounce.code}"
  end

  # this test email suggests the library fails on this email;
  # mail.part[0] includes a specific status code (5.1.1 User unknown)
  # but the library tests mail.part[1], which returns the general code (5.0.0)
  # either the test email is not a good example, or the parsing could be improved
  def test_user_unknown
    bounce = test_bounce('tt_bounce_07')
    assert_equal '5.0.0', bounce.code
  end

  def test_permanent_failure
    bounce = test_bounce('tt_bounce_08')
    assert_equal '5.3.2', bounce.code

    bounce = test_bounce('tt_bounce_09')
    assert_equal '5.3.2', bounce.code
  end

  def test_undefined_temporary_failure
    bounce = test_bounce('tt_bounce_10')
    assert_equal '4.0.0', bounce.code
  end

  # Added because kept getting errors with malformed bounce messages
  def test_malformed_bounce
    bounce = test_bounce('malformed_bounce_01')
    assert_equal '5.1.1', bounce.code
  end

  # Added because kept getting errors with unknown code messages
  def test_unknown_code
    bounce = test_bounce('unknown_code_bounce_01')
    assert bounce.is_bounce?
    assert_equal 'unknown', bounce.code
    assert_equal BounceEmail::TYPE_HARD_FAIL, bounce.type
    assert_equal 'unknown', bounce.reason
  end
end
