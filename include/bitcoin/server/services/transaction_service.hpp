/**
 * Copyright (c) 2011-2023 libbitcoin developers (see AUTHORS)
 *
 * This file is part of libbitcoin.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef LIBBITCOIN_SERVER_TRANSACTION_SERVICE_HPP
#define LIBBITCOIN_SERVER_TRANSACTION_SERVICE_HPP

#include <memory>
#include <bitcoin/protocol.hpp>
#include <bitcoin/server/define.hpp>
#include <bitcoin/server/settings.hpp>

namespace libbitcoin {
namespace server {

class server_node;

// This class is thread safe.
// Subscribe to transaction acceptances into the transaction memory pool.
class BCS_API transaction_service
  : public bc::protocol::zmq::worker
{
public:
    typedef std::shared_ptr<transaction_service> ptr;

    /// Construct a transaction service.
    transaction_service(bc::protocol::zmq::authenticator& authenticator,
        server_node& node, bool secure);

    /// Start the service.
    bool start() NOEXCEPT override;

protected:
    typedef bc::protocol::zmq::socket socket;

    virtual bool bind(socket& xpub, socket& xsub);
    virtual bool unbind(socket& xpub, socket& xsub);

    // Implement the service.
    virtual void work() override;

private:
    bool handle_transaction(const system::code& ec,
        system::chain::transaction::cptr tx);
    void publish_transaction(system::chain::transaction::cptr tx);

    // These are thread safe.
    const bool secure_;
    const std::string security_;
    const bc::server::settings& settings_;
    const bc::protocol::settings& external_;
    const bc::protocol::settings internal_;
    const bc::protocol::endpoint service_;
    const bc::protocol::endpoint worker_;
    bc::protocol::zmq::authenticator& authenticator_;
    server_node& node_;

    // This is protected by tx notification non-concurrency.
    uint16_t sequence_;
};

} // namespace server
} // namespace libbitcoin

#endif
