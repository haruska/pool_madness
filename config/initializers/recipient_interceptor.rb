if Rails.env.staging?
  Mail.register_interceptor RecipientInterceptor.new(
    ENV["EMAIL_RECIPIENTS"],
                                subject_prefix: "[MADNESS-STAGING]")
end
