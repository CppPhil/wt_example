#ifndef INCG_WE_GLOBAL_HPP
#define INCG_WE_GLOBAL_HPP
#include <memory>
#include <utility>

namespace Wt {
} // namespace Wt

using namespace Wt;

template<typename Ty, typename Deleter = std::default_delete<Ty>>
using Up = std::unique_ptr<Ty, Deleter>;

template<typename Ty>
using Sp = std::shared_ptr<Ty>;

template<typename Ty, typename... Args>
Up<Ty> mu(Args&&... args)
{
  return std::make_unique<Ty>(std::forward<Args>(args)...);
}

template<typename Ty, typename... Args>
Sp<Ty> ms(Args&&... args)
{
  return std::make_shared<Ty>(std::forward<Args>(args)...);
}
#endif // INCG_WE_GLOBAL_HPP
