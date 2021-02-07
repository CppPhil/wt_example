#ifndef INCG_WE_HELLO_APPLICATION_HPP
#define INCG_WE_HELLO_APPLICATION_HPP
#include <Wt/WApplication.h>
#include <Wt/WEnvironment.h>
#include <Wt/WLineEdit.h>
#include <Wt/WText.h>

#include <pl/noncopyable.hpp>

#include "global.hpp"

namespace we {
class HelloApplication : public WApplication {
public:
  using this_type = HelloApplication;
  using base_type = WApplication;

  PL_NONCOPYABLE(HelloApplication);

  HelloApplication(const WEnvironment& environment);

private:
  WLineEdit* m_nameEdit;
  WText*     m_greeting;
};
} // namespace we
#endif // INCG_WE_HELLO_APPLICATION_HPP
