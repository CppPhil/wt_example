#include <Wt/WBreak.h>
#include <Wt/WContainerWidget.h>
#include <Wt/WPushButton.h>

#include "hello_application.hpp"

namespace we {
HelloApplication::HelloApplication(const WEnvironment& environment)
  : base_type{environment}, m_nameEdit{nullptr}, m_greeting{nullptr}
{
  setTitle("Hello world");

  root()->addWidget(mu<WText>("Your name, please? "));
  m_nameEdit = root()->addWidget(mu<WLineEdit>());
  WPushButton* const button{root()->addWidget(mu<WPushButton>("Greet me."))};
  root()->addWidget(mu<WBreak>());
  m_greeting = root()->addWidget(mu<WText>());
  auto greet{
    [this] { m_greeting->setText("Hello there, " + m_nameEdit->text()); }};
  button->clicked().connect(greet);
}
} // namespace we
