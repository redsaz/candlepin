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
package org.fedoraproject.candlepin.model;

import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 * Represents the actual Entitlement record.
 */
@XmlRootElement
@XmlAccessorType(XmlAccessType.PROPERTY)
public class Entitlement extends BaseModel {
    
    private Owner owner;
    private EntitlementPool pool;
    private List<Entitlement> childEntitlements;
    
    private Date startDate;

    /**
     * default ctor
     */
    public Entitlement() {
        super(null);
    }
    
    /**
     * @param uuid unique id of the entitlement
     */
    public Entitlement(String uuid) {
        super(uuid);
    }
    
    /**
     * @return the org
     */
    @XmlTransient
    public Owner getOwner() {
        return owner;
    }

    /**
     * @param ownerIn the owner to set
     */
    public void setOwner(Owner ownerIn) {
        this.owner = ownerIn;
    }

    /**
     * @return the childEntitlements
     */
    public List<Entitlement> getChildEntitlements() {
        return childEntitlements;
    }

    /**
     * @param childEntitlements the childEntitlements to set
     */
    public void setChildEntitlements(List<Entitlement> childEntitlements) {
        this.childEntitlements = childEntitlements;
    }

    
    /**
     * @return Returns the product.
     */
    public Product getProduct() {
        return this.pool.getProduct();
    }

    
    /**
     * @return Returns the pool.
     */
    public EntitlementPool getPool() {
        return pool;
    }

    
    /**
     * @param poolIn The pool to set.
     */
    public void setPool(EntitlementPool poolIn) {
        pool = poolIn;
    }

    
    /**
     * @return Returns the startDate.
     */
    public Date getStartDate() {
        return startDate;
    }

    
    /**
     * @param startDateIn The startDate to set.
     */
    public void setStartDate(Date startDateIn) {
        startDate = startDateIn;
    }

    
}
