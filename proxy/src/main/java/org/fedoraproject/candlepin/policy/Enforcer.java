/**
 * Copyright (c) 2009 Red Hat, Inc.
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
package org.fedoraproject.candlepin.policy;

import org.fedoraproject.candlepin.model.Consumer;
import org.fedoraproject.candlepin.model.Entitlement;
import org.fedoraproject.candlepin.model.EntitlementPool;

public interface Enforcer {
	
	/**
	 * Validate that a consumer can consume an entitlement for a product.
	 * 
	 * Ensures sufficient entitlements remain, but also verifies all attributes 
	 * on the product and relevant entitlement pool pass using the current 
	 * policy.
	 * 
	 * This is run prior to granting an entitlement.
	 *
	 * @param consumer Consumer who wishes to consume an entitlement.
	 * @param product Product consumer wishes to have access too.
	 * @return TODO
	 */
	public ValidationResult validate(Consumer consumer, EntitlementPool enitlementPool);

	/**
	 * Execute post entitlement actions, which are also contained within the rules document.
	 *
	 * This is run following the granting of an entitlement.
	 *
	 * @param ent The entitlement that was just granted.
	 */
	public void runPostEntitlementActions(Entitlement ent);
}
