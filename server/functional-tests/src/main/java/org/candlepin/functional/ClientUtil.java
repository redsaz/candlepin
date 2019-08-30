/**
 * Copyright (c) 2009 - 2019 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 *
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation.
 */
package org.candlepin.functional;

import org.candlepin.client.ApiClient;
import org.candlepin.client.model.UserCreationRequest;
import org.candlepin.client.model.UserDTO;
import org.candlepin.client.resources.UsersApi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;

/**
 * Utility for creating various ApiClients
 */
@Component
public class ClientUtil {
    private final ApiClientBuilder apiClientBuilder;

    private ApiClient adminApiClient;
    private ApiClientProperties coreProperties;

    @Autowired
    public ClientUtil(@Qualifier("adminApiClient") ApiClient adminApiClient,
        ApiClientProperties coreProperties,
        ApiClientBuilder apiClientBuilder) {
        this.adminApiClient = adminApiClient;
        this.coreProperties = coreProperties;
        this.apiClientBuilder = apiClientBuilder;
    }

    public ApiClient newUserAndClient(String username, String ownerKey)
        throws RestClientException {
        String password = TestUtil.randomString(10);
        UserCreationRequest userReq = new UserCreationRequest();
        userReq.setUsername(username);
        userReq.setPassword(password);

        UsersApi usersApi = new UsersApi(adminApiClient);
        UserDTO user = usersApi.createUser(userReq);

        TestUtil testUtil = new TestUtil(apiClientBuilder);
        testUtil.createAllAccessRoleForUser(ownerKey, user);

        return apiClientBuilder
            .withUsername(username)
            .withPassword(password)
            .withDebug(coreProperties.getDebug())
            .build();
    }

}
